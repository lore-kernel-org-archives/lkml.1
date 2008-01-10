Return-Path: <linux-kernel-owner+w=401wt.eu-S1757067AbYAJLKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067AbYAJLKX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 06:10:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbYAJLKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 06:10:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48979 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752820AbYAJLKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 06:10:07 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1199906358.9393.324.camel@moss-spartans.epoch.ncsc.mil>
References: <1199906358.9393.324.camel@moss-spartans.epoch.ncsc.mil> <1199902278.9393.283.camel@moss-spartans.epoch.ncsc.mil> <1197307397.18120.72.camel@moss-spartans.epoch.ncsc.mil> <1197305173.18120.60.camel@moss-spartans.epoch.ncsc.mil> <20071205193818.24617.79771.stgit@warthog.procyon.org.uk> <20071205193859.24617.36392.stgit@warthog.procyon.org.uk> <25037.1197306473@redhat.com> <17868.1199897484@redhat.com> <1316.1199904980@redhat.com> 
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: dhowells@redhat.com, Daniel J Walsh <dwalsh@redhat.com>,
       casey@schaufler-ca.com, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM settings for task actions [try #2]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Thu, 10 Jan 2008 11:09:58 +0000
Message-ID: <4917.1199963398@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Smalley <sds@tycho.nsa.gov> wrote:

> If you have a "SELinux:  policy loaded with handle_unknown=allow"
> message in your /var/log/messages, then new classes/perms that are not
> yet known to the policy will be allowed by default, so the operation
> will be permitted by the kernel.

I don't.  How do I set it?

David
