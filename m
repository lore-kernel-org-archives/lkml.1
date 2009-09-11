Return-Path: <linux-kernel-owner+w=401wt.eu-S1752280AbZIKHRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbZIKHRK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 03:17:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbZIKHRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 03:17:09 -0400
Received: from brick.kernel.dk ([93.163.65.50]:52418 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585AbZIKHRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 03:17:08 -0400
Date: Fri, 11 Sep 2009 09:17:10 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Frans Pop <elendil@planet.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [long] Another BFS versus CFS shakedown
Message-ID: <20090911071710.GB18599@kernel.dk>
References: <200909090142.41738.elendil@planet.nl> <20090911062032.GB27833@elte.hu> <200909110904.50487.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909110904.50487.elendil@planet.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 11 2009, Frans Pop wrote:
> On Friday 11 September 2009, Ingo Molnar wrote:
> > Note, the one you used was a still buggy version of latt.c producing
> > bogus latency numbers - you will need the fix to it attached below.
> 
> Yes, I'm aware of that and have already copied Jens' latest version.

BTW, I put it in a git repo, it quickly gets really confusing with so
many version going around. So that can be accessed here:

git://git.kernel.dk/latt.git

and as with my other repos, snapshots are automatically generated every
hour when new commits have been made. To get the very latest latt and
not have to use git, download:

http://brick.kernel.dk/snaps/latt-git-latest.tar.gz

-- 
Jens Axboe

