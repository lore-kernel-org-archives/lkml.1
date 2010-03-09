Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405Ab0CIVra (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 16:47:30 -0500
Received: from tundra.namei.org ([65.99.196.166]:53135 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754780Ab0CIVr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 16:47:26 -0500
Date: Wed, 10 Mar 2010 08:47:04 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: Chihau Chau <chihau@gmail.com>, paulmck@linux.vnet.ibm.com, mingo@elte.hu,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Security: key: keyring: fix some code style issues
In-Reply-To: <6837.1268169949@redhat.com>
Message-ID: <alpine.LRH.2.00.1003100846570.21376@tundra.namei.org>
References: <1268089894-28691-1-git-send-email-chihau@gmail.com> <6837.1268169949@redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Mar 2010, David Howells wrote:

> Chihau Chau <chihau@gmail.com> wrote:
> 
> > From: Chihau Chau <chihau@gmail.com>
> > 
> > This fixes to include <linux/uaccess.h> instead <asm/uaccess.h> and some
> > code style issues like to put a else sentence below close brace '}' and
> > to replace a tab instead of some space characters.
> > 
> > Signed-off-by: Chihau Chau <chihau@gmail.com>
> 
> Acked-by: David Howells <dhowells@redhat.com>


Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

-- 
James Morris
<jmorris@namei.org>
