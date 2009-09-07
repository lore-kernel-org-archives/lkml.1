Return-Path: <linux-kernel-owner+w=401wt.eu-S1752331AbZIGMhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331AbZIGMhR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 08:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141AbZIGMhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 08:37:15 -0400
Received: from tundra.namei.org ([65.99.196.166]:55070 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080AbZIGMhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 08:37:12 -0400
Date: Mon, 7 Sep 2009 22:36:59 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KEYS: Fix default security_session_to_parent()
In-Reply-To: <20090907122417.754.63235.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.2.00.0909072236440.9851@tundra.namei.org>
References: <20090907203857.023912f8.sfr@canb.auug.org.au> <20090907122417.754.63235.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Sep 2009, David Howells wrote:

> Fix the default security_session_to_parent() in linux/security.h to have a
> body.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Thanks!


Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next


-- 
James Morris
<jmorris@namei.org>
