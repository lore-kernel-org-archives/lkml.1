Return-Path: <linux-kernel-owner+w=401wt.eu-S1763144AbZBYWvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763144AbZBYWvW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 17:51:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757700AbZBYWvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 17:51:11 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58531 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757790AbZBYWvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 17:51:10 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [Bug #12409] NULL pointer dereference at get_stats()
Date: Wed, 25 Feb 2009 23:51:05 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: kernel-testers@vger.kernel.org, frederik.deweerdt@xprog.eu,
       linux-kernel@vger.kernel.org
References: <HFSEX4uppGO.A.JSG.2yzoJB@chimera> <LLno3yT_fnC.A.jjH.nzzoJB@chimera> <200902240354.n1O3sous011760@www262.sakura.ne.jp>
In-Reply-To: <200902240354.n1O3sous011760@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902252351.05870.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 February 2009, Tetsuo Handa wrote:
> Rafael J. Wysocki wrote:
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12409
> > Subject		: NULL pointer dereference at get_stats()
> > Submitter	: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
> > Date		: 2008-12-30 12:53 (56 days old)
> > References	: http://marc.info/?l=linux-kernel&m=123064167008695&w=4
> > Handled-By	: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
> > 
> I couldn't reproduce this problem in native and KVM environments.
> This problem seems to be VMware specific and priority is low.
> Alok Kataria queued this problem.
> Thus, this problem has not yet solved but mainline kernels don't need to wait
> for this problem.

Thanks, I've dropped it from my list.

Rafael
