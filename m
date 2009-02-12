Return-Path: <linux-kernel-owner+w=401wt.eu-S1757611AbZBLJ04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611AbZBLJ04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 04:26:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbZBLJ0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 04:26:38 -0500
Received: from tundra.namei.org ([65.99.196.166]:4214 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754126AbZBLJ0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 04:26:38 -0500
Date: Thu, 12 Feb 2009 20:25:25 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, haradats@nttdata.co.jp,
       takedakn@nttdata.co.jp
Subject: Re: [TOMOYO #15 0/8] TOMOYO Linux
In-Reply-To: <200902120653.n1C6rc9u027772@www262.sakura.ne.jp>
Message-ID: <alpine.LRH.1.10.0902122024130.18751@tundra.namei.org>
References: <20090205081810.331987920@nttdata.co.jp> <alpine.LRH.1.10.0902121632160.18265@tundra.namei.org> <200902120653.n1C6rc9u027772@www262.sakura.ne.jp>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Feb 2009, Tetsuo Handa wrote:

> James Morris wrote:
> > Applied to 
> > git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next
> Thank you.
> 
> > Please fix the following issue detected by sparse:
> Oh, sorry.
> 
> What can I do next?

Testing after merges with Linus would be useful.

> ----------
> Subject: TOMOYO: Fix sparse warning.
> 

Applied.

-- 
James Morris
<jmorris@namei.org>
