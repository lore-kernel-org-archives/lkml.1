Return-Path: <linux-kernel-owner+w=401wt.eu-S1756543AbYG3GqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543AbYG3GqJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 02:46:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbYG3Gpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 02:45:55 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:34024 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751075AbYG3Gpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 02:45:54 -0400
Date: Wed, 30 Jul 2008 08:45:53 +0200
From: Sebastian Siewior <lkml@ml.breakpoint.cc>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Oops in 2.6.26-rc1: in
	kernel/sched.c:sched_power_savings_store()
Message-ID: <20080730064553.GA23828@Chamillionaire.breakpoint.cc>
References: <E1KO36q-0004K6-DL@closure.thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <E1KO36q-0004K6-DL@closure.thunk.org>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Theodore Ts'o | 2008-07-30 00:16:20 [-0400]:

>
>Here is the dmesg; the oops seems to be from this shell script (see
>below) when writing to /sys/devices/system/cpu/sched_mc_power_savings.
Could this be the fix: http://lkml.org/lkml/2008/7/29/423

>       	    					- Ted
Sebastian
