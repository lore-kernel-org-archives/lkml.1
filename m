Return-Path: <linux-kernel-owner+w=401wt.eu-S1751530AbXBVJ17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530AbXBVJ17 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 04:27:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751532AbXBVJ17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 04:27:59 -0500
Received: from aa012msr.fastwebnet.it ([85.18.95.72]:44868 "EHLO
	aa012msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbXBVJ16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 04:27:58 -0500
Date: Thu, 22 Feb 2007 10:26:31 +0100
From: Paolo Ornati <ornati@fastwebnet.it>
To: Michael Opdenacker <michael-lists@free-electrons.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [TRIVIAL] Fixing occurrences of "the the "
Message-ID: <20070222102631.231bf605@localhost>
In-Reply-To: <200702220927.28393.michael-lists@free-electrons.com>
References: <200702220927.28393.michael-lists@free-electrons.com>
X-Mailer: Sylpheed-Claws 2.4.0 (GTK+ 2.10.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Feb 2007 09:27:28 +0100
Michael Opdenacker <michael-lists@free-electrons.com> wrote:

> -	  Note the the latest Xeons (Xeon 51xx and 53xx) are not based on the
> +	  Note the latest Xeons (Xeon 51xx and 53xx) are not based on the

shouldn't this be "Note that the"?  (and so on)

IOW: some of these are typos.

Some time ago I've done a similar patch for "Documentation/" (remove
duplicated words) and fallen in the same mistake :)

-- 
	Paolo Ornati
	Linux 2.6.20 on x86_64
