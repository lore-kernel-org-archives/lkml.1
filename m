Return-Path: <linux-kernel-owner+w=401wt.eu-S934168AbYBUVsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934168AbYBUVsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 16:48:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934363AbYBUVrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 16:47:51 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:59684 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934268AbYBUVru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 16:47:50 -0500
X-Greylist: delayed 533 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Feb 2008 16:47:50 EST
Date: Thu, 21 Feb 2008 13:38:19 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen: Implement getgeo for Xen virtual block device.
In-Reply-To: <47BDEA5E.4070800@goop.org>
Message-ID: <alpine.LFD.1.00.0802211337220.19896@woody.linux-foundation.org>
References: <47BDE731.60801@goop.org> <alpine.LFD.1.00.0802211315190.19896@woody.linux-foundation.org> <47BDEA5E.4070800@goop.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 21 Feb 2008, Jeremy Fitzhardinge wrote:
> 
> OK.  Have you fixed it, or shall I resend?

I'll fix it, but I want people to know so that I don't have to fix things 
like this in the future (*).

			Linus

(*) I keed, I keed. Of *course* I'll have to fix things like this in the 
future too. But hopefully not quite as often.
