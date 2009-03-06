Return-Path: <linux-kernel-owner+w=401wt.eu-S1755079AbZCFN4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079AbZCFN4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 08:56:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755071AbZCFN4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 08:56:08 -0500
Received: from adsl99-243.ath.forthnet.gr ([79.103.126.243]:37338 "EHLO
	vergina.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843AbZCFN4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 08:56:07 -0500
Message-ID: <49B12B71.7030300@asyr.hopto.org>
Date: Fri, 06 Mar 2009 15:56:01 +0200
From: Thanasis <thanasis@asyr.hopto.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090112)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: jffs2 and kernel config for SDHC Memory Cards
References: <49B127AB.6070202@asyr.hopto.org>
In-Reply-To: <49B127AB.6070202@asyr.hopto.org>
Content-Type: text/plain; charset=ISO-8859-7
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 03/06/2009 03:39 PM Thanasis wrote the following:
> I want to use two of these Transcend¢s Class 6 SDHC (SD High-Capacity)
> Memory Cards,
> http://www.transcendusa.com/Products/ModDetail.asp?ModNo=147&LangNo=0&Func1No=1&Func2No=13
> as part of the filesystem in a netbook (Acer A110L), will mount /home on
> one, and /tmp and /var on the other.
> 
> Q1: Should I format them as jffs2?
> 
> Q2: What modules/configuration options should I enable in the kernel
> (2.6.28) ?
> 
> # uname -a
> Linux atom 2.6.28-gentoo-r2 #1 SMP PREEMPT Fri Mar 6 00:00:27 EET 2009
> i686 Intel(R) Atom(TM) CPU N270 @ 1.60GHz GenuineIntel GNU/Linux
> :-)
> 

Let me rephrase my questions in order to be clearer:
Q1: In order to achieve wear leveling should I format them as jffs2?
Q2: In order to achieve wear leveling, any specific options I should
enable in kernel (2.6.28) configuration?
;-)
