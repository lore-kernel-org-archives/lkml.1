Return-Path: <linux-kernel-owner+w=401wt.eu-S934617AbXHNTDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934617AbXHNTDe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 15:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933987AbXHNTDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 15:03:05 -0400
Received: from aa012msr.fastwebnet.it ([85.18.95.72]:37574 "EHLO
	aa012msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933930AbXHNTDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 15:03:03 -0400
Date: Tue, 14 Aug 2007 21:02:46 +0200
From: Paolo Ornati <ornati@fastwebnet.it>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-usb-devel@lists.sourceforge.net,
       Alan Stern <stern@rowland.harvard.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] spontaneous disconnect with "usb-storage:
 implement autosuspend"
Message-ID: <20070814210246.0c25643d@localhost>
In-Reply-To: <200708142033.23158.oliver@neukum.org>
References: <20070814131557.5653d991@localhost>
	<200708141746.16958.oliver@neukum.org>
	<20070814183857.28997de1@localhost>
	<200708142033.23158.oliver@neukum.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2007 20:33:22 +0200
Oliver Neukum <oliver@neukum.org> wrote:

> Exactly. This is not reliable. It needs to be done in kernel. This patch
> should do it.

ok, this one works  :)

I suspect that there are many more broken devices out there ;)


thanks,

-- 
	Paolo Ornati
	Linux 2.6.23-rc3-gbfefa254 on x86_64
