Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab0CEVBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 16:01:45 -0500
Received: from mail-pz0-f194.google.com ([209.85.222.194]:50703 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab0CEVBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 16:01:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=xC7cAeq5x5z/1N5GFOAuHsudDl6HL7/fg6s9wdqsl+FrZyL1MOKy1U6GujoKWpA1pi
         giMbFyn7SW/cRdAXyLSYmVk2Cxd6h6uOX1SpboA4NopyQX+Th+4G+STBr3V8HLx2syI6
         uxKHVUiIeJrBDpizwuLmzw+RGAie8V1wCr7Bs=
MIME-Version: 1.0
In-Reply-To: <e7bd23c31003051138k14436b42t5bf544c375413c6c@mail.gmail.com>
References: <20100305151754.GB2505@tempa>
	 <20100305.072612.186421758.davem@davemloft.net>
	 <20100305154009.GC2505@tempa>
	 <20100305.074835.159078083.davem@davemloft.net>
	 <20100305160434.GE2505@tempa> <20100305164615.GC6000@thunk.org>
	 <e7bd23c31003051138k14436b42t5bf544c375413c6c@mail.gmail.com>
Date: Fri, 5 Mar 2010 13:01:43 -0800
Message-ID: <e7bd23c31003051301p2e7295d4x99fab466e897061e@mail.gmail.com>
Subject: Re: [git pull] drm request 3
From: Corbin Simpson <mostawesomedude@gmail.com>
To: tytso@mit.edu, Daniel Stone <daniel@fooishbar.org>,
       David Miller <davem@davemloft.net>, skeggsb@gmail.com, airlied@linux.ie,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
       dri-devel@lists.sf.net, mingo@elte.hu, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 5, 2010 at 11:38 AM, Corbin Simpson
<mostawesomedude@gmail.com> wrote:
> I was trying my hardest to not say anything, but...
>
> [blah blah Fedora blah Ubuntu blah staging blah blah]
>
> That said... Code probably is moving too fast inside nouveau. There is
> a bit of a wall to go through to get new patches upstream, which one
> would hope would inspire some developer restraint. intel and radeon
> both still have most (if not all) of the legacy code needed by ancient
> userspaces, and both DDX drivers are doing multiple-branch releases to
> keep old userspace interfaces alive for people unable to update their
> kernels. It might be useful for the nouveau guys to really seriously
> consider code before it leaves their trees and enters mainline;
> writing code that you won't commit to is quite lame for the obvious
> reasons, but also for some unobvious reasons, e.g. it makes you look
> like you don't actually know what you're doing and would rather just
> keep reinventing wheels without justifying and testing your design
> choices. (This is also why I was not exactly pleased with the
> suggestion of retooling all of the r600 userspace over a change to the
> CS system; we just spent the better part of a year moving everything
> over to CS!)

Strike this paragraph. After talking with the nouveau guys again, I
don't think they were doing anything out of the ordinary for staging
drivers. Frustrating, sure, but not anything worth a 200-post flame
war.

Also, I am a tool, don't know what I'm talking about, not actually a
nouveau dev, etc.

~ C.

-- 
Only fools are easily impressed by what is only
barely beyond their reach. ~ Unknown

Corbin Simpson
<MostAwesomeDude@gmail.com>
