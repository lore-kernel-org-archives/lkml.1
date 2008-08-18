Return-Path: <linux-kernel-owner+w=401wt.eu-S1753871AbYHRMxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871AbYHRMxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 08:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752031AbYHRMxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 08:53:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780AbYHRMxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 08:53:03 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080817011711.GA17528@spacedout.fries.net>
References: <20080817011711.GA17528@spacedout.fries.net> <20080814103728.13651.1528.stgit@warthog.procyon.org.uk>
To: David Fries <david@fries.net>
Cc: dhowells@redhat.com, sfr@canb.auug.org.au, jmorris@namei.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Fix setting of PF_SUPERPRIV by __capable() [BROKEN]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Mon, 18 Aug 2008 13:52:36 +0100
Message-ID: <17007.1219063956@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Fries <david@fries.net> wrote:

> The first two submissions this patch had parent for the argument, the third
> one has child then parent and fails to compile with SECURITY disabled.
> Please apply the following patch.

Yeah...  It seems I found an older version of the patch.  I seem to have too
many instances floating around in various trees.

Acked-by: David Howells <dhowells@redhat.com>
