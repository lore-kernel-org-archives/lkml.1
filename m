Return-Path: <linux-kernel-owner+w=401wt.eu-S937376AbZDJWIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937376AbZDJWIt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 18:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755224AbZDJWIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 18:08:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50385 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763123AbZDJWIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 18:08:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090410192529.GA25551@uranus.ravnborg.org>
References: <20090410192529.GA25551@uranus.ravnborg.org> <19057.1239370935@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Cc: dhowells@redhat.com, akpm@linux-foundation.org, linux-am33-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [GIT PULL] MN10300: Remove obsolete include/asm-mn10300/.gitignore
Date: Fri, 10 Apr 2009 23:07:17 +0100
Message-ID: <21602.1239401237@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following changes since commit d848223808c5d21e1b3cea090047e34722c6254b:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../dhowells/linux-2.6-mn10300

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-2.6-mn10300.git master

David Howells (1):
      MN10300: Remove obsolete .gitignore from include/asm-mn10300

 include/asm-mn10300/.gitignore |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)
 delete mode 100644 include/asm-mn10300/.gitignore
