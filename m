Return-Path: <linux-kernel-owner+w=401wt.eu-S932565AbXGLU3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932565AbXGLU3y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 16:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756046AbXGLU3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 16:29:47 -0400
Received: from SMTP.andrew.cmu.edu ([128.2.10.83]:35952 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789AbXGLU3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 16:29:46 -0400
From: Jeremy Maitin-Shepard <jbms@cmu.edu>
To: linux-kernel@vger.kernel.org
Subject: Re: Hibernation Redesign
References: <200707081737.21932.a1426z@gawab.com> <87644rcc7a.fsf@jbms.ath.cx>
	<46954212.7060105@rtr.ca> <200707120117.24549.a1426z@gawab.com>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Thu, 12 Jul 2007 16:29:45 -0400
In-Reply-To: <200707120117.24549.a1426z@gawab.com> (Al Boldi's message of
	"Thu\, 12 Jul 2007 01\:17\:24 +0300")
Message-ID: <87ir8p2wna.fsf@jbms.ath.cx>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi <a1426z@gawab.com> writes:

> Mark Lord wrote:
>> Jeremy Maitin-Shepard wrote:
>> > I'll certainly admit the kexec idea is vaporware currently,

> Your idea is starting to become a reality with this thread:
> "[PATCH 0/2] Kexec jump: The first step to kexec base hibernation"

Someone else pointed out that the idea was actually proposed by Andrew
Morton over a year ago, but it didn't get very much consideration then.

It is good to see that quite a few people are thinking about it now,
though, and that Ying Huang has started writing some code.

-- 
Jeremy Maitin-Shepard
