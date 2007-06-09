Return-Path: <linux-kernel-owner+w=401wt.eu-S1032601AbXFIArl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032601AbXFIArl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 20:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968361AbXFIArd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 20:47:33 -0400
Received: from terminus.zytor.com ([192.83.249.54]:42048 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968138AbXFIArc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 20:47:32 -0400
Message-ID: <4669F8A1.1050205@zytor.com>
Date: Fri, 08 Jun 2007 17:47:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andrew Lyon <andrew.lyon@gmail.com>
CC: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] Re: 4Gb ram not showing up
References: <Pine.LNX.4.58.0706061356310.2657@be1.lrz>	 <20070606143723.GF10008@csclub.uwaterloo.ca>	 <46673135.30105@zytor.com>	 <f4527be0706061541ifd49a8fg60442532d72f1d06@mail.gmail.com>	 <46682FED.2080506@zytor.com> <f4527be0706071037l5278fe61v1a733ab874aec136@mail.gmail.com>
In-Reply-To: <f4527be0706071037l5278fe61v1a733ab874aec136@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Lyon wrote:
> 
> I have run memtest86+ for days at a time on both systems with no errors
> at all.
> 
> broken hardware i guess, i am not surprised about the abit board, ive
> had nothing but trouble with abit motherboards and do not use them any
> more, but the supermicro is a xeon server board and i was using
> kingston ram, i wouldnt expect that to have issues.
> 
> latest bios on both.
> 

And have you verified that it's specced for the memory load you're
putting on it?  Not all platforms can use every slot with certain kinds
of DIMMs, depending on chip and rank count.

	-hpa
