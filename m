Return-Path: <linux-kernel-owner+w=401wt.eu-S1763516AbXEWOS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763516AbXEWOS7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 10:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755343AbXEWOSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 10:18:51 -0400
Received: from nommos.sslcatacombnetworking.com ([67.18.224.114]:30978 "EHLO
	nommos.sslcatacombnetworking.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755048AbXEWOSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 10:18:50 -0400
Date: Wed, 23 May 2007 09:14:07 -0500 (CDT)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@localhost.localdomain
To: Johannes Berg <johannes@sipsolutions.net>
cc: Simon Horman <horms@verge.net.au>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       ppc-dev dev ML <linuxppc-dev@ozlabs.org>
Subject: Re: Kconfig warnings on latest GIT
In-Reply-To: <1179928646.14317.6.camel@johannes.berg>
Message-ID: <Pine.LNX.4.64.0705230913420.535@localhost.localdomain>
References: <200705080004.14570.ismail@pardus.org.tr> 
 <20070508143127.38fafa3c.kim.phillips@freescale.com>  <4640D988.1040504@freescale.com>
 <20070510051042.GA16812@verge.net.au>  <1178811570.3806.18.camel@johannes.berg>
  <20070511012216.GB10715@verge.net.au>  <1178883937.8896.11.camel@johannes.berg>
  <20070514013230.GJ3588@verge.net.au>  <1179147311.2647.47.camel@johannes.berg>
  <Pine.LNX.4.64.0705140923470.24559@gate.crashing.org> 
 <1179159951.2647.49.camel@johannes.berg>  <943F0161-121D-4697-AE69-78BD605A8033@kernel.crashing.org>
 <1179928646.14317.6.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - nommos.sslcatacombnetworking.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.crashing.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007, Johannes Berg wrote:

> On Wed, 2007-05-23 at 07:37 -0500, Kumar Gala wrote:
>
> > Was my patch ok, if so I'll push it up through my git tree to paul?
>
> Yeah, looks fine to me, or will the ARCH=ppc folks then scream and want
> that added to the Kconfig there as well?

I can't imagine they will since pmac is only supported in ARCH=powerpc.

- k
