Return-Path: <linux-kernel-owner+w=401wt.eu-S1753614AbYH0VWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614AbYH0VWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 17:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbYH0VWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 17:22:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095AbYH0VWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 17:22:40 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080827185845.GA25669@us.ibm.com>
References: <20080827185845.GA25669@us.ibm.com> <200808262057.51606.agruen@suse.de> <200808271729.18220.agruen@suse.de> <20080827160439.GA12085@us.ibm.com> <200808271857.48651.agruen@suse.de>
To: "Serge E. Hallyn" <serue@us.ibm.com>, jmorris@namei.org
Cc: dhowells@redhat.com, Andreas Gruenbacher <agruen@suse.de>,
       "Andrew G. Morgan" <morgan@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] file capabilities: Add no_file_caps switch
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Wed, 27 Aug 2008 22:14:46 +0100
Message-ID: <31237.1219871686@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn <serue@us.ibm.com> wrote:

> Ok, cool.  In that case - David I was a little surprised to find that
> patch not applied in Linus' tree.  You sent it quite some time ago,
> didn't you?  Were you planning on trying again to push it soon?

I think you were getting my patches confused.

I had two patches of note:

 (1) Fix PF_SUPERPRIV that I was pushing to get upstream, and is now upstream.

 (2) Neuter sys_capset().  I've been holding this off for the next merge
     window as it isn't a bugfix, unlike (1).  Perhaps I should ask James to
     push it to Linus.  James?

David
