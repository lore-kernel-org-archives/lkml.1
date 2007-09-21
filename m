Return-Path: <linux-kernel-owner+w=401wt.eu-S1765356AbXIUXSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765356AbXIUXSa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 19:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762131AbXIUXSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 19:18:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761532AbXIUXSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 19:18:20 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <533105.53764.qm@web36610.mail.mud.yahoo.com>
References: <533105.53764.qm@web36610.mail.mud.yahoo.com>
To: casey@schaufler-ca.com
Cc: dhowells@redhat.com, viro@ftp.linux.org.uk, hch@infradead.org,
       Trond.Myklebust@netapp.com, sds@tycho.nsa.gov,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 00/22] Introduce credential record
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Sat, 22 Sep 2007 00:18:01 +0100
Message-ID: <10185.1190416681@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler <casey@schaufler-ca.com> wrote:

> They are nonetheless in effect and (heaven forbid) should they be
> abused you don't want to hide the facts from concerned observers.

Because, I suspect, what the observer through /proc should see is what the
process thinks it is doing, not what is transparently going on behind the
scenes.

David
