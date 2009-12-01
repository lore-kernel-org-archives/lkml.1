Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbZLASaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbZLASaP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 13:30:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753464AbZLASaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 13:30:14 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:44071 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbZLASaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 13:30:13 -0500
Message-ID: <4B1560B6.3020907@gmail.com>
Date: Tue, 01 Dec 2009 19:30:14 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: William Allen Simpson <william.allen.simpson@gmail.com>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: warning: massive change to conditional coding style in net?
References: <4B13A025.7000103@gmail.com> <20091130.123644.203668577.davem@davemloft.net> <4B1558D8.4010804@gmail.com>
In-Reply-To: <4B1558D8.4010804@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 01 Dec 2009 19:30:16 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

William Allen Simpson a écrit :
 
> If these changes had been mentioned a month or two ago, as part of a
> thorough review, it could have been discussed earlier.  Instead, it's
> like being nibbled by mice.

William,

This is absolutely _not_ possible to comment a 1000+ lines patches in one shot,
being your patch or not.

It would take _hours_ of work, even for David.

We use a step-by-step process, with limited feedbacks, because nobody is paid
to make your life easier. We patiently gave you a lot of advices and yet
you complain again and again.

After 15/30 minutes of reviewing patches, and collecting some suggestions,
the average reviewer stops its review, sends a feedback, and waits for next
patch submission. [hoping patch author will be pro_active and check all its
patches, not the precise points that were specificaly raised.]

Yes, sometime we notice a point at round eleven, instead of first/second round,
because more important things were noticed at prior rounds.

I honestly hope you change your mind, or I wont even read your next patch
submissions, wait for the official RFC and code the damn thing myself or wait for
some kind developper willing to do the job, in the normal process.

You can copy this mail to all man kind, it wont make your patches magically
ready for inclusion.

Respectfully,
Eric
