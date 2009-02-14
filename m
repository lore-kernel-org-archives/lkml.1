Return-Path: <linux-kernel-owner+w=401wt.eu-S1757569AbZBNXbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569AbZBNXbJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 18:31:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756478AbZBNXXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 18:23:00 -0500
Received: from rosi.naasa.net ([212.8.0.13]:42103 "EHLO rosi.naasa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758107AbZBNXW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 18:22:58 -0500
From: Joerg Platte <jplatte@naasa.net>
Reply-To: jplatte@naasa.net
To: Frans Pop <elendil@planet.nl>
Subject: Re: cpuinfo shows wrong MHz value
Date: Sun, 15 Feb 2009 00:22:14 +0100
User-Agent: KMail/1.9.9
Cc: Kasper Sandberg <lkml@metanurb.dk>, linux-kernel@vger.kernel.org
References: <200902142217.51655.jplatte@naasa.net> <1234651096.13338.15.camel@localhost> <200902142346.30449.elendil@planet.nl>
In-Reply-To: <200902142346.30449.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200902150022.39271.jplatte@naasa.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 14. Februar 2009 schrieb Frans Pop:
> On Saturday 14 February 2009, Kasper Sandberg wrote:
> > I dont think cpu frequency scaling can suddenly make a cpu go from
> > 1.6ghz to 13ghz, but if it can, i sure want one!
>
> Ah, sorry. I misread the message and thought the problem was it was
> showing 1.3 GHz, which would be a very normal scaling value.
>
> However, it would have helped if the problem had been stated explicitly in
> the original message instead of letting others interpret the raw data.

Sorry, I should have made it clear that my computer is running with 13 GHz (at 
leat according to the kernel). With previous kernels (IIRC 2.6.26) cpuinfo 
showed the correct value.

regards,
Jörg
