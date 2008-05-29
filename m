Return-Path: <linux-kernel-owner+w=401wt.eu-S1753980AbYE2IJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbYE2IJG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 04:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbYE2IIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 04:08:50 -0400
Received: from ozlabs.org ([203.10.76.45]:35876 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbYE2IIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 04:08:49 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch -mmotm] docbook: duplicate kernel-locking doc merge
Date: Thu, 29 May 2008 18:08:36 +1000
User-Agent: KMail/1.9.9
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>
References: <20080527221327.dfcb4fb6.randy.dunlap@oracle.com> <20080527221419.2f5ca991.akpm@linux-foundation.org>
In-Reply-To: <20080527221419.2f5ca991.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805291808.36861.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 May 2008 15:14:19 Andrew Morton wrote:
> On Tue, 27 May 2008 22:13:27 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > Looks like Rusty's doc additions were duplicated.
>
> ah, thanks, that's me trying to pick up patches which aren't in linux-next
> yet.  I normally don't bother doing that unless there's a lot of material
> involved.
>
> I'll zap the erroneously-included
> rusty-misc-doc_add_a_chapter_about_trylock_functions_bug_9011.patch

If it's any consolation, I too got confused when Linus merged that: the patch
applies multiple times without fuzz.  Impressive.

Cheers,
Rusty.
