Return-Path: <linux-kernel-owner+w=401wt.eu-S1753497AbYLLTkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbYLLTkQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 14:40:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbYLLTj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 14:39:59 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:61159 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbYLLTj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 14:39:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=x-authentication-warning:to:cc:subject:references:from:in-reply-to
         :message-id:lines:user-agent:mime-version:content-type:date;
        b=jrwlgqKPwL2INv4J2d95XclC2JJFj492/DHBdmQFTer8RuIG2qghZus+zrfoTtSIvg
         Z+92kR8XxwRlWfNXD195wKBBUNf6ZvEDNihO4zVNhE//1JPcgiQQoa8ueVh8hv3dWn62
         KDnkkkGHUh5tx0sawFPBrRrI5msuNScjIlZLY=
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, git@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Simplified GIT usage guide
References: <20081212182827.28408.40963.stgit@warthog.procyon.org.uk>
From: Jakub Narebski <jnareb@gmail.com>
In-Reply-To: <20081212182827.28408.40963.stgit@warthog.procyon.org.uk>
Message-ID: <m33agtgp2v.fsf@localhost.localdomain>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Fri, 12 Dec 2008 11:39:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> writes:

> Add a guide to using GIT's simpler features.

Wouldn't it be better to update either "Git User's Manual",
or http://book.git-scm.com?

See also: http://git.or.cz/gitwiki/GitDocumentation (including "Git
Magic", "Git in Nutshell", "Git for computer scientists" and "Git from
bottoms up"
-- 
Jakub Narebski
Poland
ShadeHawk on #git
