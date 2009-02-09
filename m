Return-Path: <linux-kernel-owner+w=401wt.eu-S1754931AbZBIRW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931AbZBIRW4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 12:22:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756008AbZBIRW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 12:22:28 -0500
Received: from mail.deathmatch.net ([70.167.247.36]:1566 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595AbZBIRW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:22:26 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: Roland Dreier <rdreier@cisco.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Brandeburg\, Jesse" <jesse.brandeburg@intel.com>
Subject: Re: [Bug #12600] i915 lockdep warning
Date: Mon, 9 Feb 2009 12:21:26 -0500
Message-Id: <20090209172031.M25268@bobcopeland.com>
In-Reply-To: <adaljsgbeh6.fsf@cisco.com>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera> <sWhNs83kKPE.A.xaG.-20jJB@chimera> <adaljsgbeh6.fsf@cisco.com>
X-Mailer: OpenWebMail 2.53 
X-OriginatingIP: 149.101.1.121 (bob)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 08 Feb 2009 17:12:21 -0800, Roland Dreier wrote
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12600
>  > Subject		: i915 lockdep warning
>  > Submitter	: Brandeburg, Jesse <jesse.brandeburg@intel.com>
>  > Date		: 2009-01-13 23:17 (27 days old)
>  > References	: http://marc.info/?l=linux-kernel&m=123188898423532&w=4
> 
> Looks like a dup of 12491 to me.
> 
>  - R.

I can also confirm that Roland's patch fixes it for me.

-- 
Bob Copeland %% www.bobcopeland.com


