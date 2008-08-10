Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbYHJWqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbYHJWqb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 18:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751352AbYHJWqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 18:46:24 -0400
Received: from tundra.namei.org ([65.99.196.166]:49626 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054AbYHJWqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 18:46:23 -0400
Date: Mon, 11 Aug 2008 08:45:53 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cred: add static, remove extern on function
 definitions
In-Reply-To: <12546.1218366064@redhat.com>
Message-ID: <alpine.LRH.1.10.0808110845380.3084@tundra.namei.org>
References: <1218322619.24441.6.camel@brick> <12546.1218366064@redhat.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Aug 2008, David Howells wrote:

> Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
> > kernel/cred.c:460:13: warning: function 'revert_creds' with external linkage has definition
> > kernel/cred.c:72:6: warning: symbol 'put_tgcred' was not declared. Should it be static?
> > 
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> 
> Acked-by: David Howells <dhowells@redhat.com>

Applied to:
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next-creds


-- 
James Morris
<jmorris@namei.org>
