Return-Path: <linux-kernel-owner+w=401wt.eu-S1764895AbYBVEYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764895AbYBVEYn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 23:24:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755031AbYBVEYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 23:24:34 -0500
Received: from an-out-0708.google.com ([209.85.132.244]:17731 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849AbYBVEYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 23:24:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=xO+dAWHS90YM0uhEB27PffvsR+yUoqiWL8AlHojIOjiqzeTZh05QCrW2j32MQyqAiWa3bi7o1FSx6Y/LP644LChyH6cCdLujoYuVwuVnXASQCkqdFy/qvdSfJHyS//wgWvaZlSdLPBe35XOOa0vFsT4z3wJV9wucUhw+0FFRPA8=
Message-ID: <97a0a9ac0802212024w62dbfb03ye62c51744e853b36@mail.gmail.com>
Date: Thu, 21 Feb 2008 21:24:32 -0700
From: "Gordon Farquharson" <gordonfarquharson@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [RFC] [PATCH] Fix b43 driver build for arm
Cc: "Michael Buesch" <mb@bu3sch.de>,
       "Russell King" <rmk+lkml@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, linville@tuxdriver.com,
       stefano.brivio@polimi.it, "Linus Torvalds" <torvalds@osdl.org>,
       "Andrew Morton" <akpm@osdl.org>, viro@ftp.linux.org.uk
In-Reply-To: <20080220193709.GD21139@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <97a0a9ac0802181403ja79c32v864b093414b2755@mail.gmail.com>
	 <200802191141.26952.mb@bu3sch.de>
	 <97a0a9ac0802191644x693cd34cq6b167756df9c65f4@mail.gmail.com>
	 <200802201544.05192.mb@bu3sch.de>
	 <20080220193709.GD21139@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam

On Wed, Feb 20, 2008 at 12:37 PM, Sam Ravnborg <sam@ravnborg.org> wrote:

>  Option 1) is the worst of the three as that can cost
>  of many hours bug-hunting.
>  Option 3) may seem optimal but I do not like to add more
>  complexity to this part of the build. And really I do not
>  know a reliable way to detech when we do cross builds anyway.
>
>  Leaving us with option 2) that is simple, strighforward and harmless.

Are you willing to sign off on and commit the patch?

Gordon

-- 
Gordon Farquharson
GnuPG Key ID: 32D6D676
