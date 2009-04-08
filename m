Return-Path: <linux-kernel-owner+w=401wt.eu-S1764381AbZDHVvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764381AbZDHVvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 17:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759414AbZDHVvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 17:51:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39928 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756479AbZDHVvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 17:51:20 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090408214014.GA10366@uranus.ravnborg.org>
References: <20090408214014.GA10366@uranus.ravnborg.org> <20090408205610.GA9970@uranus.ravnborg.org> <20090408184455.GB332@uranus.ravnborg.org> <21081.1239214221@redhat.com> <20090408183011.24150.43310.stgit@warthog.procyon.org.uk> <24317.1239216477@redhat.com> <26753.1239225955@redhat.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: dhowells@redhat.com, jeremy@goop.org, mingo@elte.hu,
       akpm@linux-foundation.org, x86@kernel.org, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, nickpiggin@yahoo.com.au, tglx@linutronix.de,
       ysato@users.sourceforge.jp
Subject: Re: [PATCH] FRV: Use <asm-generic/pgtable.h> in NOMMU mode
Date: Wed, 08 Apr 2009 22:48:57 +0100
Message-ID: <27338.1239227337@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg <sam@ravnborg.org> wrote:

> --follow is needed to follow renames when doing git log.

So what's '-M' for?

David
