Return-Path: <linux-kernel-owner+w=401wt.eu-S1762814AbYHHWjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762814AbYHHWjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbYHHWjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 18:39:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56956 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbYHHWjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 18:39:05 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080808172141.GY14495@cs181140183.pp.htv.fi>
References: <20080808172141.GY14495@cs181140183.pp.htv.fi> <1218214935.3146.5.camel@dhcppc0>
To: Thomas Meyer <thomas@m3y3r.de>, Adrian Bunk <bunk@kernel.org>
Cc: dhowells@redhat.com, Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-Next <linux-next@vger.kernel.org>
Subject: Re: next-20080808: bash: fork: Resource temporarily unavailable
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Fri, 08 Aug 2008 23:32:15 +0100
Message-ID: <17923.1218234735@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Adrian Bunk <bunk@kernel.org> wrote:

> The only commits that touched kernel/fork.c between next-20080807 and 
> next-20080808 are David's CRED patches.
> 
> David, can you look at this?

I can, but I'll need a config file as it boots fine for me and passes the LTP
testsuites I've run on it.

David
