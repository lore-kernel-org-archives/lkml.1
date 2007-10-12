Return-Path: <linux-kernel-owner+w=401wt.eu-S1760945AbXJLNBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760945AbXJLNBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 09:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758822AbXJLNBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 09:01:06 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:52833 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756822AbXJLNBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 09:01:03 -0400
Date: Fri, 12 Oct 2007 15:01:02 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Al Boldi <a1426z@gawab.com>
cc: Netfilter Developer Mailing List 
	<netfilter-devel@vger.kernel.org>,
       netdev@vger.kernel.org, linux-net@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kaber@trash.net
Subject: Re: [RFD] iptables:  mangle table obsoletes filter table
In-Reply-To: <200710120031.42805.a1426z@gawab.com>
Message-ID: <Pine.LNX.4.64.0710121449370.23981@fbirervta.pbzchgretzou.qr>
References: <200710120031.42805.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 12 2007 00:31, Al Boldi wrote:
>
>With the existence of the mangle table, how useful is the filter table?

A similar discussion was back in March 2007.
http://marc.info/?l=netfilter-devel&m=117394977210823&w=2
http://marc.info/?l=netfilter-devel&m=117400063907706&w=2

in the end, my proposal was something like
http://jengelh.hopto.org/GFX0/nf_proposal2.svg
