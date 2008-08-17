Return-Path: <linux-kernel-owner+w=401wt.eu-S1754574AbYHQNKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbYHQNKV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 09:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752780AbYHQNKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 09:10:08 -0400
Received: from tundra.namei.org ([65.99.196.166]:46516 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724AbYHQNKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 09:10:08 -0400
Date: Sun, 17 Aug 2008 23:08:26 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Alexander Beregalov <a.beregalov@gmail.com>
cc: David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
       Casey Schaufler <casey@schaufler-ca.com>, morgan@kernel.org,
       viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT] Re: [PATCH] security.h: fix build failure 
In-Reply-To: <alpine.LRH.1.10.0808172242480.13264@tundra.namei.org>
Message-ID: <alpine.LRH.1.10.0808172307170.13513@tundra.namei.org>
References: <20080817013420.GA7622@orion> <alpine.LRH.1.10.0808172242480.13264@tundra.namei.org>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's a pullable version here:

The following changes since commit 
b09c3e3f1710b554348c98e78fbf4a661918779a:
  Huang Weiyi (1):
        removed unused #include <version.h>

are available in the git repository at:

  
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6 for-linus

Alexander Beregalov (1):
      security.h: fix build failure

 include/linux/security.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)




-- 
James Morris
<jmorris@namei.org>
