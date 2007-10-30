Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbXJ3OPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbXJ3OPH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 10:15:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319AbXJ3OO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 10:14:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296AbXJ3OO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 10:14:56 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <b1c6420f0710300557j57cfc554m458adc7dbeeed610@mail.gmail.com>
References: <b1c6420f0710300557j57cfc554m458adc7dbeeed610@mail.gmail.com> <20071029122759.2846.83510.stgit@warthog.procyon.org.uk>
To: "Suzuki Takashi" <suzuki.takashi@gmail.com>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       linux-am33-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [Linux-am33-list] [PATCH 0/2] MN10300: Add the MN10300 architecture to Linux kernel [try #2]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Tue, 30 Oct 2007 14:14:49 +0000
Message-ID: <15631.1193753689@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Suzuki Takashi <suzuki.takashi@gmail.com> wrote:

> Why don't you use `am33' for the arch name?

History and the fact that 'mn10300' is what MEI called their arch when they
originally gave us (RH) their kernel.  There are kernels already out there
running on consumer devices for which it is the mn10300 arch.

David
