Return-Path: <linux-kernel-owner+w=401wt.eu-S1759951AbYDKK2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759951AbYDKK2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 06:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758899AbYDKK2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 06:28:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758878AbYDKK2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 06:28:42 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080411.031642.193716019.davem@davemloft.net>
References: <20080411.031642.193716019.davem@davemloft.net> <1207885132.22001.85.camel@brick> <15208.1207908688@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: dhowells@redhat.com, harvey.harrison@gmail.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 2/2] kernel: Move arches to use common unaligned access
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Fri, 11 Apr 2008 11:27:55 +0100
Message-ID: <20196.1207909675@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> wrote:

> No, I think it has something to do with what cases GCC is allowed to
> optimize the call inline and what cases it cannot wrt.  alignment of
> datums.

As he says in his comment, in fact.

David
