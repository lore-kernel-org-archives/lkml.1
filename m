Return-Path: <linux-kernel-owner+w=401wt.eu-S1760207AbZASMtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760207AbZASMtk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 07:49:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759025AbZASMtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 07:49:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:47629 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758981AbZASMtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 07:49:31 -0500
Date: Mon, 19 Jan 2009 04:51:44 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] async fixes and documentation
Message-ID: <20090119045144.632b67a0@infradead.org>
In-Reply-To: <20090119134527.60ca1119@gondolin>
References: <20090119134527.60ca1119@gondolin>
Organization: Intel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jan 2009 13:45:27 +0100
Cornelia Huck <cornelia.huck@de.ibm.com> wrote:

> Hi,
> 
> here are the async patches I currently have on my disk.
> 
> [1/3] async: Fix running list handling.
> [2/3] async: Handle kthread_run() return codes.
> [3/3] async: Add some documentation.
> 
> Patch 2 now uses msleep() to recover instead of scheduling.
> 

thanks for the update; I was about to send the older versions of these
to Linus today; I'll refresh


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
