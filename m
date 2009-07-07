Return-Path: <linux-kernel-owner+w=401wt.eu-S1756085AbZGGCto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbZGGCto (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 22:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230AbZGGCte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 22:49:34 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:35667
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134AbZGGCte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 22:49:34 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #13668] Can't boot 2.6.30 powerpc kernel under qemu.
Date: Mon, 6 Jul 2009 21:49:34 -0500
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "Jeremy Kerr" <jk@ozlabs.org>
References: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera> <bXZeuxPQAWE.A.RDG.3_oUKB@chimera>
In-Reply-To: <bXZeuxPQAWE.A.RDG.3_oUKB@chimera>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907062149.35062.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 July 2009 19:01:05 Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.29 and 2.6.30.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13668
> Subject		: Can't boot 2.6.30 powerpc kernel under qemu.
> Submitter	: Rob Landley <rob@landley.net>
> Date		: 2009-06-27 18:08 (10 days old)
> References	: http://lkml.org/lkml/2009/6/27/159

Resolved, it just required a configuration change.

Rob
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
