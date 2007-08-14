Return-Path: <linux-kernel-owner+w=401wt.eu-S1757136AbXHNJoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136AbXHNJoL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 05:44:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754181AbXHNJnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 05:43:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603AbXHNJnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 05:43:49 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070813111559.GG24018@shell.boston.redhat.com>
References: <20070813111559.GG24018@shell.boston.redhat.com> <46C03885.7000109@redhat.com>
To: Chris Snook <csnook@redhat.com>
Cc: dhowells@redhat.com, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
       Segher Boessenkool <segher@kernel.crashing.org>,
       "Luck, Tony" <tony.luck@intel.com>, Chris Friesen <cfriesen@nortel.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: [PATCH 7/23] make atomic_read() and atomic_set() behavior consistent on frv
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Tue, 14 Aug 2007 10:42:31 +0100
Message-ID: <1205.1187084551@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Snook <csnook@redhat.com> wrote:

> Use volatile consistently in atomic.h on frv.

Acked-By: David Howells <dhowells@redhat.com>
