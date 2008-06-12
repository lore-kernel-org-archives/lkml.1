Return-Path: <linux-kernel-owner+w=401wt.eu-S1757884AbYFLJuD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884AbYFLJuD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 05:50:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbYFLJtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 05:49:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863AbYFLJtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 05:49:51 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080612072955.GA8097@linux-sh.org>
References: <20080612072955.GA8097@linux-sh.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Bryan Wu <cooloney@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nommu: Correct kobjsize() page validity checks.
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Thu, 12 Jun 2008 10:48:56 +0100
Message-ID: <27332.1213264136@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Paul Mundt <lethal@linux-sh.org> wrote:

> This implements a few changes on top of the recent kobjsize() refactoring
> introduced by commit 6cfd53fc03670c7a544a56d441eb1a6cc800d72b.
> ...
>
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> Reviewed-by: Christoph Lameter <clameter@sgi.com>

Works for me.

Acked-by: David Howells <dhowells@redhat.com>
