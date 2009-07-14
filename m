Return-Path: <linux-kernel-owner+w=401wt.eu-S1751275AbZGNLDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275AbZGNLDl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 07:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbZGNLDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 07:03:41 -0400
Received: from viefep12-int.chello.at ([62.179.121.32]:50480 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbZGNLDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 07:03:40 -0400
X-SourceIP: 213.93.53.227
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Raistlin <raistlin@linux.it>
Cc: Chris Friesen <cfriesen@nortel.com>, Douglas Niehaus <niehaus@ittc.ku.edu>,
       Henrik Austad <henrik@austad.us>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       "James H. Anderson" <anderson@cs.unc.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Ted Baker <baker@cs.fsu.edu>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Noah Watkins <jayhawk@soe.ucsc.edu>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>
In-Reply-To: <1247568455.9086.115.camel@Palantir>
References: <200907102350.47124.henrik@austad.us>
	 <1247336891.9978.32.camel@laptop>  <4A594D2D.3080101@ittc.ku.edu>
	 <1247412708.6704.105.camel@laptop> <1247499843.8107.548.camel@Palantir>
	 <4A5B61DF.8090101@nortel.com>  <1247568455.9086.115.camel@Palantir>
Content-Type: text/plain
Date: Tue, 14 Jul 2009 13:03:35 +0200
Message-Id: <1247569415.7500.95.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-14 at 12:47 +0200, Raistlin wrote:
> [1] http://feanor.sssup.it/%7Elipari/papers/rtss2001-bwi.ps.gz

That link seems to require a user/pass combination.

