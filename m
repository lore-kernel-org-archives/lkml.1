Return-Path: <linux-kernel-owner+w=401wt.eu-S1758140AbZAQGIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140AbZAQGIv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 01:08:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751905AbZAQGIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 01:08:41 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34977 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779AbZAQGIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 01:08:40 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090115181612.GA27762@elte.hu>
References: <20090115181612.GA27762@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Michael LeMay <mdlemay@epoch.ncsc.mil>,
       James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Paul Moore <paul.moore@hp.com>, Eric Paris <eparis@redhat.com>
Subject: Re: [slab corruption] BUG key_jar: Poison overwritten
Date: Sat, 17 Jan 2009 06:07:51 +0000
Message-ID: <16916.1232172471@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> wrote:

> -tip testing found the rather scary looking slab corruption:

Unfortunately, I'm not in a position to look into this much right now:-(.
I'll see if I can find a test machine next week, but if not, it'll be Feb
before I can do anything about it.

That said, what sort of testing were you doing?

David
