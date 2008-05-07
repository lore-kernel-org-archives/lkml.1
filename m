Return-Path: <linux-kernel-owner+w=401wt.eu-S933067AbYEGI0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933067AbYEGI0v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 04:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754782AbYEGI0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 04:26:35 -0400
Received: from hpsmtp-eml18.kpnxchange.com ([213.75.38.118]:50993 "EHLO
	hpsmtp-eml18.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754085AbYEGI0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 04:26:32 -0400
From: Frans Pop <elendil@planet.nl>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Horrendous Audio Stutter - current git
Date: Wed, 7 May 2008 10:26:27 +0200
User-Agent: KMail/1.9.9
Cc: Parag Warudkar <parag.warudkar@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>
References: <82e4877d0805011714m35a47753q58cca706b7af6557@mail.gmail.com> <1209717278.13978.136.camel@twins>
In-Reply-To: <1209717278.13978.136.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805071026.29540.elendil@planet.nl>
X-OriginalArrivalTime: 07 May 2008 08:26:30.0115 (UTC) FILETIME=[0CD88B30:01C8B01C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 May 2008, Peter Zijlstra wrote:
> > Under kernel compilation load (make -j8) audio is very much unusable
> > on current linux-2.6.git - The stutter is so bad I can hardly tell
> > what song I am listening to :)
> > Even with make -j4 it still skips but not that badly.

What's the current status here?
With mainline v2.6.26-rc1-110-ga153063 (which has latest sched patches), I 
still get very bad audio skips with GROUP_SCHED enabled.

Cheers,
FJP
