Return-Path: <linux-kernel-owner+w=401wt.eu-S1161228AbXD2U5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161228AbXD2U5d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 16:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161227AbXD2U5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 16:57:33 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:18130 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161172AbXD2U5b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 16:57:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=Etc84KBtIqjSkl+cZ5v7S/MRV5k6SCPCI1BonQNKhVunzX71X/Te05uUH7Ijn5MF531KpmTl6NMZElJ6LJbleAZvMeGZlz5ggMQ/BUlChKHsAP/0tyw1Gm6cX/aE06Pb39sOmMg+CcNF6PR4WlSZJ+kqX+j9P6HL6ygPluZAW8s=
Date: Sun, 29 Apr 2007 22:56:57 +0200
From: Diego Calleja <diegocg@gmail.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-Id: <20070429225657.a501ab5a.diegocg@gmail.com>
In-Reply-To: <20070429201729.GQ3468@stusta.de>
References: <20070428195320.GZ3468@stusta.de>
	<20070428202701.GA30343@flint.arm.linux.org.uk>
	<20070428224904.GE3468@stusta.de>
	<alpine.LFD.0.98.0704281601060.9964@woody.linux-foundation.org>
	<p73d51n1fup.fsf@bingen.suse.de>
	<alpine.LFD.0.98.0704290848360.9964@woody.linux-foundation.org>
	<20070429173500.GA30248@one.firstfloor.org>
	<alpine.LFD.0.98.0704291040580.9964@woody.linux-foundation.org>
	<20070429180909.GA30604@one.firstfloor.org>
	<20070429214007.9ea12e96.diegocg@gmail.com>
	<20070429201729.GQ3468@stusta.de>
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.10.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Sun, 29 Apr 2007 22:17:29 +0200, Adrian Bunk <bunk@stusta.de> escribió:

> Bugzilla might not be perfect, but it works and it's better than doing 
> it by hand.

The good thing about the wiki is that it doesn't exclude bugzilla. It's
just a "regressions list", it doesn't intends to replace bugzilla. If a bug
doesn't gets fixed for a while, I don't think it's very useful to keep it
forever in the list like you do in the bugzilla, because I don't think
it's possible to fix every single bug, and it steals you time to fix bugs
that you are able to fix.

It's not great but it's the best clone of you we've found 8)
