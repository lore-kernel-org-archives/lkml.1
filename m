Return-Path: <linux-kernel-owner+w=401wt.eu-S1757582AbYARJtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582AbYARJtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 04:49:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753560AbYARJtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 04:49:15 -0500
Received: from hs-out-0708.google.com ([64.233.178.248]:40644 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751017AbYARJtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 04:49:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oIiwYMjWsas3CxBgF2jKLMst4uKUeNc+zGUYzhjVkZrCy1I79ylvAqBgtyUN/qfnXHRQra0EBetYTsjYQ/zLUKRJvXXksSx6AZp3u6aWL/bKCTXT449U9hcTQ02KW+zRXq5q+A0lZ6zuv1pM2Uuo5w2TyldJsIW/XwIHJOjvM4U=
Message-ID: <a8e1da0801180149g3a6c0914sceb5e40bf90fd963@mail.gmail.com>
Date: Fri, 18 Jan 2008 17:49:11 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Tetsuo Handa" <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [2.6.24-rc8-mm1] Locking API boot-time self-tests hangs.
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Zan Lynx" <zlynx@acm.org>
In-Reply-To: <200801180938.m0I9cjvA065103@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801180120.m0I1KBuC065806@www262.sakura.ne.jp>
	 <20080117181935.02294863.akpm@linux-foundation.org>
	 <200801180319.m0I3Ju9N089501@www262.sakura.ne.jp>
	 <20080117204247.5318e500.akpm@linux-foundation.org>
	 <200801180640.m0I6enPI029212@www262.sakura.ne.jp>
	 <a8e1da0801172259s3377895dwb0b2ca1dd781d11b@mail.gmail.com>
	 <20080118091810.GG24337@elte.hu>
	 <200801180938.m0I9cjvA065103@www262.sakura.ne.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 18, 2008 5:38 PM, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
> Hello.
>
> Ingo Molnar wrote:
> > is the patch below already in -rc8-mm1? hmm ... it appears it's not.
> > Could you give it a try?

Yes , It fixes that problem.

>
> This patch solved this bug.

So quick :)

>
> Thank you.
>
