Return-Path: <linux-kernel-owner+w=401wt.eu-S1946122AbXBPUXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946122AbXBPUXW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 15:23:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946126AbXBPUXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 15:23:21 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:54254 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946122AbXBPUXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 15:23:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=fbBrR0H8EounLMKs5lcwRyi2GGaVNM9IVSPoIfDj87rxeZoQdzVAhRDt10W/6K3loMq7rd6mNW+rrdthShx91C8zDa1wmSceBSu/t4e5p7m67Av4/FrniFL+8gh6dExbwfdRjplyEEBbArAZwGYhMOgFmU9anbVEwwTffdLnw2s=
Date: Fri, 16 Feb 2007 23:20:36 +0300
From: "Cyrill V. Gorcunov" <gorcunov@gmail.com>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: [patch 05/11] syslets: core code
Message-ID: <20070216202036.GA10190@cvg>
References: <Pine.LNX.4.64.0702150920130.20368@woody.linux-foundation.org> <20070215181059.GC20997@2ka.mipt.ru> <Pine.LNX.4.64.0702151019210.20368@woody.linux-foundation.org> <20070215190413.GA23953@2ka.mipt.ru> <Pine.LNX.4.64.0702151120260.20368@woody.linux-foundation.org> <20070216085706.GA22868@2ka.mipt.ru> <Pine.LNX.4.64.0702160753120.20368@woody.linux-foundation.org> <20070216160525.GA21160@2ka.mipt.ru> <2c0942db0702160853s18f650ccsa7270c047d94a41b@mail.gmail.com> <20070216165854.GA18522@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070216165854.GA18522@2ka.mipt.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 16, 2007 at 07:58:54PM +0300, Evgeniy Polyakov wrote:
| Absolutely.
| And if overall system design is good, there is no problem to change
| (well, for those who fail to read to the end and understand my english
| replace 'to change' with 'to create and commit') interface to the state
| where it will satisfy all (majority of) users.
| 
| Situations when system is designed from interface down to system ends up
| with one thread per IO and huge limitations on how system is going to be
| used at all.
| 
| -- 
| 	Evgeniy Polyakov

I'm sorry for meddling in conversation but I think Linus misunderstood
you. If I'm right you propose to "create and commit" _new_ interfaces
only? I mean _changing_ of interfaces exported to user space is
very painfull... for further support. Don't swear at me if I wrote
something stupid ;)

-- 

		Cyrill

