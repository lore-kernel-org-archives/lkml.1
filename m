Return-Path: <linux-kernel-owner+w=401wt.eu-S1754755AbYIXT23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbYIXT23 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 15:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbYIXT2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 15:28:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587AbYIXT2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 15:28:20 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1222283477.4425.55.camel@calx>
References: <1222283477.4425.55.camel@calx> <1222280971.4425.42.camel@calx> <20080923053228.GA5825@wotan.suse.de> <20080914073906.GA6184@elte.hu> <20080914004442.4f8e851f.akpm@linux-foundation.org> <20080914080631.GA10720@elte.hu> <20080914221231.GG27080@wotan.suse.de> <20080917131419.e6b7622e.akpm@linux-foundation.org> <20080918111226.GD29968@elte.hu> <48D2ABFD.3040103@goop.org> <1221772310.4779.29.camel@calx> <1221877119.8533.2.camel@nimitz> <13787.1222095249@redhat.com> <22749.1222280305@redhat.com> <24051.1222282618@redhat.com> 
To: Matt Mackall <mpm@selenic.com>
Cc: dhowells@redhat.com, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh@veritas.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [patch] mm: tiny-shmem fix lor, mmap_sem vs i_mutex
Date: Wed, 24 Sep 2008 20:26:53 +0100
Message-ID: <24588.1222284413@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall <mpm@selenic.com> wrote:

> As the original author of tiny-shmem.c, I will naturally try to bear
> this in mind. The goal would be to build both a regular and a tiny
> version from one C file so that they won't diverge again in the future.

Thanks.

David
