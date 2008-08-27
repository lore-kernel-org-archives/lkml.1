Return-Path: <linux-kernel-owner+w=401wt.eu-S1757330AbYH0PZC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330AbYH0PZC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 11:25:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbYH0PYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 11:24:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753563AbYH0PYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 11:24:51 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <48B56ADA.8010808@yandex.ru>
References: <48B56ADA.8010808@yandex.ru> <20080827134541.19980.61042.stgit@warthog.procyon.org.uk> <20080827134547.19980.38813.stgit@warthog.procyon.org.uk>
To: Artem Bityutskiy <dedekind@yandex.ru>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, Serge Hallyn <serue@us.ibm.com>,
       Tony Luck <tony.luck@intel.com>, linux-ia64@vger.kernel.org
Subject: Re: [PATCH 01/59] CRED: Wrap task credential accesses in the IA64 arch
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Wed, 27 Aug 2008 16:24:38 +0100
Message-ID: <25475.1219850678@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy <dedekind@yandex.ru> wrote:

> Fine with me.

Can I count that as an Acked-by?

> Do you want us to put this patch to ubifs-2.6.git or you
> prefer to make it go together with the rest of the CRED patches?

Ummm...  I'll check.  I'm not sure exactly how Stephen wanted to play this.

David
