Return-Path: <linux-kernel-owner+w=401wt.eu-S1755594AbYHGM24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594AbYHGM24 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756134AbYHGM1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:27:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753885AbYHGMYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:24:00 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LRH.1.10.0808071843550.18106@tundra.namei.org>
References: <alpine.LRH.1.10.0808071843550.18106@tundra.namei.org> <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
To: James Morris <jmorris@namei.org>
Cc: dhowells@redhat.com, akpm@linux-foundation.org, morgan@kernel.org,
       sfr@canb.auug.org.au, viro@ftp.linux.org.uk, casey@schaufler-ca.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/24] Introduce credentials [ver #7]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Thu, 07 Aug 2008 10:32:01 +0100
Message-ID: <23715.1218101521@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris <jmorris@namei.org> wrote:

> These patches don't apply from here on:

Hmmm...  Applies for me on top of your next branch (commit ID
421fae06be9e0dac45747494756b3580643815f9).

David
