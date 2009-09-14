Return-Path: <linux-kernel-owner+w=401wt.eu-S1754770AbZINBys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbZINBys (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 21:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbZINByr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 21:54:47 -0400
Received: from mail-yx0-f191.google.com ([209.85.210.191]:45773 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbZINByq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 21:54:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=nW010uy6shrs7qgjXwK/DHzeOJvF0qioKS0VtdBbUPSlZef8uXnMFAPQdfKnSXVCn/
         BxI+FhRpFalXBnvddtO92twzrtyswHZoyMlwvhsEYv1eSzR835LQg2JM4cD1+1hmAH4K
         0eMUJRbq6CLIUAOlnoPDUmKfPUEGbvVkF6zOc=
MIME-Version: 1.0
In-Reply-To: <20090623134319.GC3026@elte.hu>
References: <20090614012457.GD5986@nowhere> <1244948719-22216-1-git-send-email-vapier@gentoo.org> 
	<8bd0f97a0906230530j1cc0efc8i85e9234b2fa0417a@mail.gmail.com> 
	<20090623134319.GC3026@elte.hu>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sun, 13 Sep 2009 21:54:28 -0400
Message-ID: <8bd0f97a0909131854l511fbcb8ve8b66a5f3b3d2113@mail.gmail.com>
Subject: Re: [PATCH v4] ftrace: document basic ftracer/ftracer graph needs
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       akpm <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 09:43, Ingo Molnar wrote:
> * Mike Frysinger wrote:
>> On Sat, Jun 13, 2009 at 23:05, Mike Frysinger wrote:
>> > While implementing ftracer and ftracer graph support, I found the exact
>> > arch implementation details to be a bit lacking (and my x86 foo ain't
>> > great).  So after pounding out support for the Blackfin arch, start
>> > documenting the requirements/details.
>>
>> Steven: were you going to pick this up ?  or should i forward to Andrew ?
>
> The .32 development window for the tracing tree starts in about a
> week. We'll probably fast-track your documentation bits to mainline
> - but until then we try to watch for regressions and make sure -rc1
> is round.

unless i missed something, this wasnt picked up
-mike
