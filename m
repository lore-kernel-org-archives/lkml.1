Return-Path: <linux-kernel-owner+w=401wt.eu-S1756919AbXJLOCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919AbXJLOCw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 10:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753609AbXJLOCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 10:02:39 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:44226 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbXJLOCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 10:02:38 -0400
Date: Fri, 12 Oct 2007 16:02:36 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Patrick McHardy <kaber@trash.net>
cc: Al Boldi <a1426z@gawab.com>,
       Netfilter Developer Mailing List 
	<netfilter-devel@vger.kernel.org>,
       netdev@vger.kernel.org, linux-net@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFD] iptables:  mangle table obsoletes filter table
In-Reply-To: <470F7B4B.2010609@trash.net>
Message-ID: <Pine.LNX.4.64.0710121553450.23981@fbirervta.pbzchgretzou.qr>
References: <200710120031.42805.a1426z@gawab.com>
 <Pine.LNX.4.64.0710121449370.23981@fbirervta.pbzchgretzou.qr>
 <200710121630.29151.a1426z@gawab.com> <Pine.LNX.4.64.0710121533360.23981@fbirervta.pbzchgretzou.qr>
 <470F7B4B.2010609@trash.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 12 2007 15:48, Patrick McHardy wrote:
>
>The netlink based iptables successor I'm currently working on allows to
>dynamically create tables with user-specified priorities and "built-in"
>chains. The only built-in tables will be those that need extra
>processing (mangle/nat). So it should be possible to set up tables
>basically any way you desire.

Will ebtables move a bit closer to iptables?

