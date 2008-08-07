Return-Path: <linux-kernel-owner+w=401wt.eu-S1756209AbYHGM1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbYHGM1a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755310AbYHGMZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:25:16 -0400
Received: from tundra.namei.org ([65.99.196.166]:37900 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754421AbYHGMZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:25:11 -0400
Date: Thu, 7 Aug 2008 19:56:13 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: akpm@linux-foundation.org, morgan@kernel.org, sfr@canb.auug.org.au,
       viro@ftp.linux.org.uk, casey@schaufler-ca.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/24] Introduce credentials [ver #7]
In-Reply-To: <23715.1218101521@redhat.com>
Message-ID: <alpine.LRH.1.10.0808071954560.18334@tundra.namei.org>
References: <alpine.LRH.1.10.0808071843550.18106@tundra.namei.org> <20080806153713.14351.91448.stgit@warthog.procyon.org.uk> <23715.1218101521@redhat.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Aug 2008, David Howells wrote:

> James Morris <jmorris@namei.org> wrote:
> 
> > These patches don't apply from here on:
> 
> Hmmm...  Applies for me on top of your next branch (commit ID
> 421fae06be9e0dac45747494756b3580643815f9).

Interesting, looks like git-am got confused when processing the patches as 
a single mailbox, but worked ok when run on a per-patch basis.


- James
-- 
James Morris
<jmorris@namei.org>
