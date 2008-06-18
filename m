Return-Path: <linux-kernel-owner+w=401wt.eu-S1753570AbYFRJlH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbYFRJlH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 05:41:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbYFRJkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 05:40:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752598AbYFRJkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 05:40:51 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080617223332.GM25911@cs181133002.pp.htv.fi>
References: <20080617223332.GM25911@cs181133002.pp.htv.fi>
To: Adrian Bunk <bunk@kernel.org>
Cc: dhowells@redhat.com, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       gerg@uclinux.org, ralf@linux-mips.org, linux-mips@linux-mips.org,
       lethal@linux-sh.org, linux-sh@vger.kernel.org,
       Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [2.6 patch] remove pcibios_update_resource() functions
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 18 Jun 2008 10:40:14 +0100
Message-ID: <20013.1213782014@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@kernel.org> wrote:

> This patch removes the unused pcibios_update_resource() functions the 
> kernel gained since.

Fine for FRV, since it's #if'd out anyway.

Acked-by: David Howells <dhowells@redhat.com>
