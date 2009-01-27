Return-Path: <linux-kernel-owner+w=401wt.eu-S1755083AbZA0LSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083AbZA0LSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 06:18:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753066AbZA0LSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 06:18:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52785 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526AbZA0LSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 06:18:36 -0500
Date: Tue, 27 Jan 2009 12:18:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jean Delvare <khali@linux-fr.org>
Cc: Rufus & Azrael <rufus-azrael@numericable.fr>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>,
       Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Subject: Re: [2.6.29-rc2-git2] compilation warnings
Message-ID: <20090127111814.GC17848@elte.hu>
References: <497EB491.6080904@numericable.fr> <20090127094445.010c4305@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090127094445.010c4305@hyperion.delvare>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Jean Delvare <khali@linux-fr.org> wrote:

> On Tue, 27 Jan 2009 08:15:29 +0100, Rufus & Azrael wrote:
> > Hi all,
> 
> First of all: you really DO NOT WANT to send a message to 4000 people
> asking for an acknowledgment of receipt.
> 
> > Here are my compilation warnings for fresh 2.6.29-rc2-git2 kernel :
> 
> Sending 33k of warning messages at once to a generic mailing list is 
> unlikely to get you anywhere. If you really want these warnings to get 
> fixed, you better find the right person to report each warning. 
> Otherwise your report has very little value.

Also, there's a systematic effort in tip/master to fix all build warnings 
on all x86 configs that are possible to trigger (with latest GCC):

  http://people.redhat.com/mingo/tip.git/README

(the new .29 warnings are not all fixed yet but work is underway)

	Ingo
