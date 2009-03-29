Return-Path: <linux-kernel-owner+w=401wt.eu-S1753872AbZC2Gj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbZC2Gj7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 02:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbZC2Gju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 02:39:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:57888 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739AbZC2Gjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 02:39:49 -0400
Subject: Re: [git-pull -tip] x86: include inverse Xmas tree patches
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Hugh Dickins <hugh@veritas.com>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090328234012.GC4957@elte.hu>
References: <1238251730.2526.2.camel@ht.satnam>
	 <Pine.LNX.4.64.0903281508410.21235@blonde.anvils>
	 <20090328234012.GC4957@elte.hu>
Content-Type: text/plain
Date: Sun, 29 Mar 2009 12:08:54 +0530
Message-Id: <1238308734.3074.3.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-03-29 at 00:40 +0100, Ingo Molnar wrote:
> * Hugh Dickins <hugh@veritas.com> wrote:
> > 
> > Please find a better use for your time.
> > 
> > Imagine, there might be developers out there with real work
> > to do in these files: all you are doing is throwing silly
> > little obstacles in their way.
> 
> Actually, now is the right time to do such changes as we've just 
> pushed all pending x86 changes upstream. And since these changes 
> reduce the chance of future patch conflicts, they do help 
> development. (in a small way)
> 
> Nevertheless i'd suggest to make this a single commit, to not 
> clobber the shortlog with it.
> 

I think individual patches will be better option, in case of unavoidable
situation we can simply revert that particular patch.

--
JSR

