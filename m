Return-Path: <linux-kernel-owner+w=401wt.eu-S1759730AbYHHXZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759730AbYHHXZV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 19:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753533AbYHHXZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 19:25:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904AbYHHXZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 19:25:07 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LRH.1.10.0808090847530.29741@tundra.namei.org>
References: <alpine.LRH.1.10.0808090847530.29741@tundra.namei.org> <20080808172141.GY14495@cs181140183.pp.htv.fi> <1218214935.3146.5.camel@dhcppc0> <17923.1218234735@redhat.com>
To: James Morris <jmorris@namei.org>
Cc: dhowells@redhat.com, Thomas Meyer <thomas@m3y3r.de>,
       Adrian Bunk <bunk@kernel.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-Next <linux-next@vger.kernel.org>
Subject: Re: next-20080808: bash: fork: Resource temporarily unavailable
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Sat, 09 Aug 2008 00:23:58 +0100
Message-ID: <16319.1218237838@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris <jmorris@namei.org> wrote:

> > I can, but I'll need a config file as it boots fine for me and passes the
> > LTP testsuites I've run on it.
> 
> Is this with linux-next or my tree?

It was actually with your tree, but I've just tested current linux-next and
that passes the LTP SELinux and syscalls testscripts too, give or take the
things that weren't passing anyway, even before my patches.

David
