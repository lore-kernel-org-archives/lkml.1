Return-Path: <linux-kernel-owner+w=401wt.eu-S1755617AbZINOiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617AbZINOiu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 10:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755593AbZINOit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 10:38:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276AbZINOis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 10:38:48 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1252787226.13780.1.camel@dhcp231-106.rdu.redhat.com>
References: <1252787226.13780.1.camel@dhcp231-106.rdu.redhat.com> <a5388f3a349a38034ec677c64677afadd0541713.1252083485.git.zohar@linux.vnet.ibm.com> <alpine.LRH.2.00.0909071215530.3222@tundra.namei.org> <20090912072450.GA6767@elte.hu> <1252748791.2305.89.camel@dhcp231-106.rdu.redhat.com> <20090912104346.GB27935@elte.hu> <20090912135808.GA17416@elte.hu> 
To: Eric Paris <eparis@redhat.com>
Cc: dhowells@redhat.com, Ingo Molnar <mingo@elte.hu>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [origin tree boot hang] lockup in key_schedule_gc()
Date: Mon, 14 Sep 2009 15:38:38 +0100
Message-ID: <21194.1252939118@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris <eparis@redhat.com> wrote:

> Adding dhowells, the keys maintainer, this one certainly isn't obvious
> to me off hand.

I've screwed up the gc mechanism.  I'm working out a patch for it.

David
