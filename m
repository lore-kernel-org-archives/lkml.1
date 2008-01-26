Return-Path: <linux-kernel-owner+w=401wt.eu-S1754551AbYAZEWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbYAZEWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 23:22:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbYAZEWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 23:22:14 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48258 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490AbYAZEWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 23:22:14 -0500
Subject: Re: [PATCH] Linux Kernel Markers Support for Proprierary Modules
From: Jon Masters <jcm@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <200801261427.34902.rusty@rustcorp.com.au>
References: <1201029235.18144.62.camel@perihelion>
	 <Pine.LNX.4.64.0801250840340.12676@fbirervta.pbzchgretzou.qr>
	 <1201275090.25284.281.camel@perihelion>
	 <200801261427.34902.rusty@rustcorp.com.au>
Content-Type: text/plain
Organization: Red Hat, Inc.
Date: Fri, 25 Jan 2008 23:21:46 -0500
Message-Id: <1201321306.32422.146.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-01-26 at 14:27 +1100, Rusty Russell wrote:

> 2) Unconditionally reject modules with a wrong module section size.  Currently 
> we have no such check, which means without KALLSYMS, anything goes.

I favor the latter, since it's safest.

Jon.


