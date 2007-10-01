Return-Path: <linux-kernel-owner+w=401wt.eu-S1756185AbXJATaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbXJATaB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 15:30:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752408AbXJAT3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 15:29:54 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:42684 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbXJAT3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 15:29:53 -0400
Date: Mon, 1 Oct 2007 21:29:52 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Bill Nottingham <notting@redhat.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Antonino Daplas <adaplas@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] make unicode default
In-Reply-To: <20071001183940.GA16413@nostromo.devel.redhat.com>
Message-ID: <Pine.LNX.4.64.0710012128550.7130@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0709291034100.22032@fbirervta.pbzchgretzou.qr>
 <20071001183940.GA16413@nostromo.devel.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 1 2007 14:39, Bill Nottingham wrote:
>Jan Engelhardt (jengelh@computergmbh.de) said: 
>> 
>> Make the vt return to the system default when it is reset.
>> Also make UTF-8 the system default.
>> Derived from http://lkml.org/lkml/2007/8/31/246
>> 
>> Tested and works as expected.
>
>Fine with me. I believe the original patch I sent went to -mm, so you 
>may need rediffing/changing to go with that.

My patch is based on a pure 2.6.23; i.e. it is assumed that your 
original patch is dropped / not-applied before patching this one (my 
variant) in.
