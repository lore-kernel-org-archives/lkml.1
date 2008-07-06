Return-Path: <linux-kernel-owner+w=401wt.eu-S1757586AbYGFNVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586AbYGFNVN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 09:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754318AbYGFNU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 09:20:58 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:41234 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915AbYGFNU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 09:20:57 -0400
Date: Sun, 6 Jul 2008 15:21:49 +0200
From: Pavel Machek <pavel@suse.cz>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Sean Young <sean@mess.org>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: Regression: boot failure on AMD Elan TS-5500
Message-ID: <20080706132148.GA3172@elf.ucw.cz>
References: <48566C88.6000702@goop.org> <20080616161944.GA53539@atlantis.8hz.com> <20080630214347.GA57988@atlantis.8hz.com> <4869558A.9020907@goop.org> <48695871.8000805@zytor.com> <48695F88.9080905@goop.org> <48696167.6050000@zytor.com> <20080701195942.GA76608@atlantis.8hz.com> <486A9257.1050302@zytor.com> <486A938D.3080009@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486A938D.3080009@goop.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-07-01 13:29:01, Jeremy Fitzhardinge wrote:
> H. Peter Anvin wrote:
>> Not really.  In particular, I really don't want to add something that is 
>> even remotely likely to break on other platforms, and a fence instruction 
>> is relatively recent.
>
> I wonder if a cpuid would do the trick?  Do we still support cpuid-less 
> processors?

We still support 386~~, AFAICT.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
