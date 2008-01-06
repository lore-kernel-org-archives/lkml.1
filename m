Return-Path: <linux-kernel-owner+w=401wt.eu-S1755975AbYAFASJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbYAFASJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 19:18:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753913AbYAFAR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 19:17:58 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:52582 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816AbYAFAR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 19:17:57 -0500
Date: Sun, 6 Jan 2008 00:17:57 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Berthold Cogel <cogel@uni-koeln.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Oops in evdev_disconnect for kernel 2.6.23.12
Message-ID: <20080106001756.GP27894@ZenIV.linux.org.uk>
References: <477A93CD.9030707@rrz.uni-koeln.de> <20080105065233.GE27894@ZenIV.linux.org.uk> <47801D70.8020504@uni-koeln.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47801D70.8020504@uni-koeln.de>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2008 at 01:14:40AM +0100, Berthold Cogel wrote:

> >There are only 4 changesets between 2.6.23 and this one affecting 
> >drivers/input
> >and only
> >8006479c9b75fb6594a7b746af3d7f1fbb68f18f and
> >6addb1d6de1968b84852f54561cc9a999909b5a9
> >appear to be relevant.  Apply to your kernel and see if it helps...
> 
> Looks as if I have to start using git ... I always feared that this day 
> will come. ;-)
> 
> If I'm able to reproduce the oops with my patched kernel, I will gladly 
> follow your advice.

AFAICS, lkml.org/lkml/2007/7/24/20 is the same patch...
