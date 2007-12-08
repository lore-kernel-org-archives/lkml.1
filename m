Return-Path: <linux-kernel-owner+w=401wt.eu-S1755647AbXLHA4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647AbXLHA4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 19:56:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbXLHA4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 19:56:17 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729AbXLHA4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 19:56:16 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20071207174456.GA6380@sergelap.austin.ibm.com>
References: <20071207174456.GA6380@sergelap.austin.ibm.com> <20071205193702.24437.76418.stgit@warthog.procyon.org.uk> <20071205193727.24437.79998.stgit@warthog.procyon.org.uk>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: dhowells@redhat.com, viro@ftp.linux.org.uk, hch@infradead.org,
       Trond.Myklebust@netapp.com, sds@tycho.nsa.gov, casey@schaufler-ca.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 5/7] Security: Change current->fs[ug]id to current_fs[ug]id()
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Sat, 08 Dec 2007 00:53:06 +0000
Message-ID: <16912.1197075186@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Serge E. Hallyn <serue@us.ibm.com> wrote:

> Could you resend patch 6?

As I said in the cover note:

A tarball of the patches is available at:

	http://people.redhat.com/~dhowells/fscache/patches/nfs+fscache-25.tar.bz2

David
