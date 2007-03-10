Return-Path: <linux-kernel-owner+w=401wt.eu-S933483AbXCJQoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933483AbXCJQoe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 11:44:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933489AbXCJQoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 11:44:34 -0500
Received: from [212.12.190.34] ([212.12.190.34]:32931 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S933483AbXCJQod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 11:44:33 -0500
From: Al Boldi <a1426z@gawab.com>
To: William Lee Irwin III <wli@holomorphy.com>
Subject: Re: Pluggable Schedulers (was: [ANNOUNCE] RSDL completely fair starvation free interactive cpu scheduler)
Date: Sat, 10 Mar 2007 19:47:11 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org
References: <200703091625.55361.a1426z@gawab.com> <200703100834.25136.a1426z@gawab.com> <20070310065927.GH2986@holomorphy.com>
In-Reply-To: <20070310065927.GH2986@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703101947.11960.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
> William Lee Irwin III wrote:
> >> A useful exercise may also be enumerating
> >> your expectations and having those who actually work with the code
> >> describe how well those are actually met.
>
> On Sat, Mar 10, 2007 at 08:34:25AM +0300, Al Boldi wrote:
> > A runtime configurable framework that allows for dynamically extensible
> > schedulers.  PlugSched seems to be a good start.
>
> Last I checked there were limits to runtime configurability centering
> around only supporting a compiled-in set of scheduling drivers, unless
> Peter's taken it the rest of the way without my noticing. It's unclear
> what you have in mind in terms of dynamic extensibility. My only guess
> would be pluggable scheduling policy/class support for individual
> schedulers in addition to plugging the individual schedulers, except
> I'm rather certain that Williams' code doesn't do anything with modules.

Correct, it doesn't, yet.  But do you think that PlugSched has the basic 
infrastructure in place to support this, or would it require a complete 
redesign/rewrite.


Thanks!

--
Al

