Return-Path: <linux-kernel-owner+w=401wt.eu-S1757812AbXLLS1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757812AbXLLS1K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 13:27:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbXLLS04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 13:26:56 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892AbXLLS0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 13:26:55 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <81862.27432.qm@web36605.mail.mud.yahoo.com>
References: <81862.27432.qm@web36605.mail.mud.yahoo.com>
To: casey@schaufler-ca.com
Cc: dhowells@redhat.com, Stephen Smalley <sds@tycho.nsa.gov>,
       Karl MacMillan <kmacmill@redhat.com>, viro@ftp.linux.org.uk,
       hch@infradead.org, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM settings for task actions [try #2]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 12 Dec 2007 18:25:29 +0000
Message-ID: <32137.1197483929@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler <casey@schaufler-ca.com> wrote:

> You may need to have an application, say cachefileselinuxcontext, that will
> read the current policy and spit out an appropriate value of "<whatever>",
> but that can be separate and LSM specific without mucking up your basic
> infrastructure applications.

What would I do with such a thing?  How would it get run?  Spat out to where?

David
