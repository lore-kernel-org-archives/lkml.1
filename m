Return-Path: <linux-kernel-owner+w=401wt.eu-S932268AbYBBFK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268AbYBBFK1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 00:10:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932109AbYBBFKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 00:10:11 -0500
Received: from keil-draco.com ([216.193.185.50]:50708 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108AbYBBFKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 00:10:10 -0500
From: Daniel Hazelton <dhazelton@enter.net>
To: Gabriel C <nix.or.die@googlemail.com>
Subject: Re: Various Errors with recent GIT
Date: Sat, 2 Feb 2008 00:09:55 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org
References: <200802012252.29454.dhazelton@enter.net> <47A3F4C7.4060406@googlemail.com>
In-Reply-To: <47A3F4C7.4060406@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802020009.56037.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 February 2008 23:42:47 Gabriel C wrote:
> Daniel Hazelton wrote:
> > Another problem is one I wasn't able to find any kind of trigger for,
> > other than just running XChat. Every so often XChat would seem to freeze
> > - but if run from the command line, switching to that terminal window and
> > hitting "ctrl-c" would cause it to rapidly update and become responsive
> > again. The freeze would happen at a random time interval that I couldn't
> > figure out.
>
> I got that Xchat problem on i686 yesterday.
>
> I'm running 2.6.24-06481-gaa62999 right now with near 4h uptime and the
> problem seems fixed.

Hrm... I'll see about updating my local git tree and building a new kernel. 
With the x86 merger if it's fixed in 32bit it is probably also fixed in 
64bit.

The other problems are a bigger concern, though. I don't like seeing warnings 
in my logs - makes me worry about the long-term stability of my systems. And 
with the apparent problem in libata I'm not too sure I will be able to 
successfully boot into a new kernel - after all, the system just spins on 
trying and retrying the drive without any progress. (And it seems random, 
though it does appear that the trick to a successful boot is to get the 
hardware completely powered down - in other words, a completely cold boot)

DRH

> > DRH
>
> Gabriel



-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
