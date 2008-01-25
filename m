Return-Path: <linux-kernel-owner+w=401wt.eu-S1760799AbYAYTEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760799AbYAYTEr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 14:04:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760652AbYAYTEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 14:04:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50921 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760646AbYAYTE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 14:04:28 -0500
Date: Fri, 25 Jan 2008 20:04:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Yinghai Lu <Yinghai.Lu@Sun.COM>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: trim ram need to check if mtrr is there v3
Message-ID: <20080125190418.GA7817@elte.hu>
References: <47993F1A.5070408@goop.org> <200801241947.55223.yinghai.lu@sun.com> <4799930B.40006@goop.org> <200801250042.53074.yinghai.lu@sun.com> <20080125110935.GA20026@elte.hu> <479A30A3.7050305@goop.org> <20080125185923.GA2518@elte.hu> <479A3222.30008@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479A3222.30008@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> I was referring to:
>
> commit 6a4544a9c8b54b82893044cb53695502cc386f00
> Author: Yinghai Lu <Yinghai.Lu@Sun.COM>
> Date:   Fri Jan 25 00:15:29 2008 +0100
>
>    x86_32: trim memory by updating e820 v3
>
> but you've answered the question...

yeah, i guess what i've pushed out just now is v3++. Does it work for 
you?

	Ingo
