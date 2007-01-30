Return-Path: <linux-kernel-owner+w=401wt.eu-S1751029AbXA3Tur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751029AbXA3Tur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 14:50:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751018AbXA3Tuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 14:50:46 -0500
Received: from wr-out-0506.google.com ([64.233.184.224]:62376 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbXA3Tup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 14:50:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EBOCrFOM3CJoZ8EqCZheQBYuM7M5PFm8f37D7T1cJhthGyDM64uOtAe6V0u2GPWmfyfQSccB6gkuoMkuplaSQkHb7muR2eWuJdyUv+MItV6MApb9lU+zEzvShJJQh7elgLAdlgf0wJGcHkMKnHPqQS04MJ+BRBzHz+9fxjp5WD0=
Message-ID: <21d7e9970701301150s42dcd5f8se7475c96bc7dad99@mail.gmail.com>
Date: Wed, 31 Jan 2007 06:50:44 +1100
From: "Dave Airlie" <airlied@gmail.com>
To: "Benjamin Herrenschmidt" <benh@kernel.crashing.org>
Subject: Re: [PATCH] gpu/radeonfb: add GPU support to radeonfb
Cc: airlied@linux.ie, linux-kernel@vger.kernel.org
In-Reply-To: <1169683666.24996.14.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1169637623985-git-send-email-airlied@linux.ie>
	 <11696376332395-git-send-email-airlied@linux.ie>
	 <11696376362911-git-send-email-airlied@linux.ie>
	 <11696376384021-git-send-email-airlied@linux.ie>
	 <1169683666.24996.14.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > This patch adds support to the radeonfb driver to use the new
> > GPU layer to driver the radeon.
>
> Unfortunately, that also massively collides with a giant radeonfb update
> that's been simmering on my HD for some time (mostly the work of Solomon
> Peachy to support ATOM BIOS and newer cards).
>
> I really need to finish some bits in there and push it out. Dave, you
> want to push your stuff first or you prefer re-adapting your stuff on
> top of mine ? I'll try to dig a patch to put in -mm for a while next
> week.

I can wait for yours as gpu_layer has become a background task that I
just pick up every few weeks and dust off.. :-)

Dave.
