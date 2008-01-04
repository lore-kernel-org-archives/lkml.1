Return-Path: <linux-kernel-owner+w=401wt.eu-S1758294AbYADIfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758294AbYADIfE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 03:35:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044AbYADIez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 03:34:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44596 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753460AbYADIey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 03:34:54 -0500
Date: Fri, 4 Jan 2008 09:34:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] This patch to profile.c fixes a few errors reported by
	checkpatch.pl
Message-ID: <20080104083442.GD22803@elte.hu>
References: <20080104003253.7a7309d8@paolo-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080104003253.7a7309d8@paolo-desktop>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com> wrote:

> Before:
> total: 25 errors, 13 warnings, 602 lines checked
> 
> After:
> total: 3 errors, 13 warnings, 602 lines checked

thanks, applied. Would you be interested in fixing the other errors and 
warnings too? (Feel free to ask how to resolve certain types of 
warnings. I just took a quick look and all the current checkpatch.pl 
output on profile.c shows genuine style issues.)

	Ingo
