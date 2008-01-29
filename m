Return-Path: <linux-kernel-owner+w=401wt.eu-S1763340AbYA2ATs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763340AbYA2ATs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 19:19:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753444AbYA2ATi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 19:19:38 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337AbYA2ATh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 19:19:37 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080124193421.888241466@szeredi.hu>
References: <20080124193421.888241466@szeredi.hu> <20080124193341.166753833@szeredi.hu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 05/26] mount options: fix afs
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Tue, 29 Jan 2008 00:19:29 +0000
Message-ID: <15159.1201565969@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> wrote:

> Add a .show_options super operation to afs.
> 
> Use generic_show_options() and save the complete option string in
> afs_get_sb().

Sounds reasonable, but I can't test it till I get back from LCA.

David
