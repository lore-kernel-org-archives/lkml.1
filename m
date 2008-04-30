Return-Path: <linux-kernel-owner+w=401wt.eu-S1762573AbYD3S1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762573AbYD3S1K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 14:27:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759388AbYD3S05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 14:26:57 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:56061 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758524AbYD3S0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 14:26:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding:sender;
        b=vNZCNhCDdw+cIkM1dqHA9zxgRHyS37IKFp1KOE0jNBdsxbYojdhUVbQj1WxrYsXTGE55xlI1Xkj3ix7oZEJDfLvV06iQM83WEiz3FBhzhLGs/YtmrVwA6WeIio+I6R7oR6kZAfqICnS22UhwfxBzA6FcKyeXPQPfGsR+4bzElVo=
Subject: Re: [PATCH 0/1] Embedded Maintainer(s), linux-embedded@vger list
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Reply-To: jwboyer@linux.vnet.ibm.com
To: David Woodhouse <dwmw2@infradead.org>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tim Bird <tim.bird@am.sony.com>
In-Reply-To: <1209577322.25560.402.camel@pmac.infradead.org>
References: <1209577322.25560.402.camel@pmac.infradead.org>
Content-Type: text/plain; charset=utf8
Date: Wed, 30 Apr 2008 13:26:49 -0500
Message-Id: <1209580009.2946.98.camel@vader.jdub.homelinux.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-1.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-30 at 18:42 +0100, David Woodhouse wrote:
> Andrew Morton has been saying recently that we need an 'embedded
> maintainer', to take responsibility for 'embedded issues' in the core
> kernel, as well as trying to improve our relationship with those using
> the Linux kernel for 'embedded' devices -- who have a reputation of
> not working with us very closely; to their detriment as well as our
> own.
> 
> Various people, including myself, have been doing that kind of thing
> on and off over the years anyway, but Andrew is probably right that
> it's worth having someone listed in the MAINTAINERS file who actually
> considers it their responsibility, and as a point of contact for
> people seeking advice, review, etc.
> 
> I've volunteered to take a more active rôle in this, and Wind River
> has agreed to assign Paul Gortmaker to it, too.  The following patch
> adds both of us to the MAINTAINERS file.

Excellent news.

> We have also set up a mailing list, linux-embedded@vger.kernel.org,
> where development related to embedded stuff can happen in a slightly
> less noisy environment than the main linux-kernel list. We'd like to
> encourage anyone working on Linux in embedded devices to join the list.

Do you see this list as a general embedded patch/issues discussion list,
a help list, a list for vendors to interact with the community, or all
of the above?

I ask because having the entry in MAINTAINERS is great, but I expect
some to be a bit confused as to what that actually means.

josh

