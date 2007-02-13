Return-Path: <linux-kernel-owner+w=401wt.eu-S1751221AbXBMJXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751221AbXBMJXt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 04:23:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbXBMJXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 04:23:48 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45010 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbXBMJXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 04:23:47 -0500
Subject: Re: ARP hidden patch vs. arp ignore/announce
From: Arjan van de Ven <arjan@infradead.org>
To: Menny Hamburger <menny@exanet.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <A6FDE6B975803043804A49F12F49028E0F5757@hawk.exanet-il.co.il>
References: <A6FDE6B975803043804A49F12F49028E0F5757@hawk.exanet-il.co.il>
Content-Type: text/plain
Organization: Intel International BV
Date: Tue, 13 Feb 2007 09:52:20 +0100
Message-Id: <1171356740.12771.54.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> If there is currently no way to provide this functionality using
> arp_ignore/arp_annonce/arp_filter or their friends, why is this still a
> patch
> And is not integrated into the mainline kernel?

eh? if you keep reading the doc it'll explain that there is arptables in
the current kernels, which is like iptables for arp, and you can do very
finegrained control with that, including the ignore stuff...


