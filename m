Return-Path: <linux-kernel-owner+w=401wt.eu-S1755764AbZFDPTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764AbZFDPTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 11:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756819AbZFDPS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 11:18:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54660 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756249AbZFDPS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 11:18:56 -0400
Date: Thu, 4 Jun 2009 08:18:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Michael S. Zick" <lkml@morethan.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Harald Welte <HaraldWelte@viatech.com>
Subject: Re: Linux 2.6.30-rc8 [also: VIA Support]
In-Reply-To: <200906040958.46018.lkml@morethan.org>
Message-ID: <alpine.LFD.2.01.0906040817090.4880@localhost.localdomain>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <200906040856.10512.lkml@morethan.org> <200906040958.46018.lkml@morethan.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Jun 2009, Michael S. Zick wrote:
> 
> Well, that one isn't anything to brag about"

So what's the problem on that machine? Is the VIA C7-M (or some random 
device in it) just buggy and it eventually hangs, or what? Has _any_ 
kernel ever worked on that machine for longer than an hour or two?

		Linus
