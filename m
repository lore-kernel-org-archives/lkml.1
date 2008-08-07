Return-Path: <linux-kernel-owner+w=401wt.eu-S1753867AbYHGM1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbYHGM1G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:27:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbYHGMZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:25:12 -0400
Received: from tundra.namei.org ([65.99.196.166]:37900 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755246AbYHGMZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:25:10 -0400
Date: Thu, 7 Aug 2008 22:03:57 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: akpm@linux-foundation.org, morgan@kernel.org, sfr@canb.auug.org.au,
       viro@ftp.linux.org.uk, casey@schaufler-ca.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/24] Introduce credentials [ver #7]
In-Reply-To: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.1.10.0808072156240.18676@tundra.namei.org>
References: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Aug 2008, David Howells wrote:

> I've brought my patchset up to date with regards the recent merge melee and
> built the patches on top of the next branch of James's security testing tree as
> per his request.

These patches are now in 
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next-creds

This is the 'next' branch + the credentials patches.

Stephen, could you add 'next-creds' to linux-next?


- James
-- 
James Morris
<jmorris@namei.org>
