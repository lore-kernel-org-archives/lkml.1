Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812AbXHISIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbXHISIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 14:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200AbXHISIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 14:08:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757299AbXHISIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 14:08:34 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <830177.29212.qm@web36605.mail.mud.yahoo.com>
References: <830177.29212.qm@web36605.mail.mud.yahoo.com>
To: casey@schaufler-ca.com
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@osdl.org, steved@redhat.com,
       trond.myklebust@fys.uio.no, linux-fsdevel@vger.kernel.org,
       linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/14] CacheFiles: Permit a process's create SID to be overridden [try #2]
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Thu, 09 Aug 2007 19:07:42 +0100
Message-ID: <20954.1186682862@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler <casey@schaufler-ca.com> wrote:

> This is SELinux specific funtionality and should be done in the
> SELinux code. You should not be adding interfaces that are SELinux
> specific, in this case using secids instead of the LSM blob interfaces.

Is using secids your only objection?  Or are you objecting to the whole
'act-as' concept?

David
