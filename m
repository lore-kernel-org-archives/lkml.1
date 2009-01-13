Return-Path: <linux-kernel-owner+w=401wt.eu-S1756411AbZAMMPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411AbZAMMPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 07:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753214AbZAMMPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 07:15:36 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54878 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752595AbZAMMPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 07:15:35 -0500
Date: Tue, 13 Jan 2009 12:15:10 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: David Rientjes <rientjes@google.com>, Bill Davidsen <davidsen@tmr.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux killed Kenny, bastard!
Message-ID: <20090113121510.68a55fe9@lxorguk.ukuu.org.uk>
In-Reply-To: <20090113115408.GA22289@ioremap.net>
References: <20090112155030.GA21063@ioremap.net>
	<20090112155239.5f677a17@lxorguk.ukuu.org.uk>
	<20090112155615.GA21350@ioremap.net>
	<20090112161931.6203f96e@lxorguk.ukuu.org.uk>
	<20090112162938.GA22647@ioremap.net>
	<496BCB7A.2010804@tmr.com>
	<20090112231728.GA23803@ioremap.net>
	<alpine.DEB.2.00.0901121746220.20329@chino.kir.corp.google.com>
	<20090113085244.GA13796@ioremap.net>
	<alpine.DEB.2.00.0901130134090.25386@chino.kir.corp.google.com>
	<20090113115408.GA22289@ioremap.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Who should adjust the scores for newly created processes? Who should
> check that processes in the first group have negative oom ajustment and
> in the second group a positive value? Who determines when its time to
> ajust the scores?

This is policy. Where does policy go ? User space

