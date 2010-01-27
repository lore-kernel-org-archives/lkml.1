Return-Path: <linux-kernel-owner+w=401wt.eu-S1754420Ab0A0LM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab0A0LM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 06:12:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754384Ab0A0LM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 06:12:26 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:58749 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367Ab0A0LM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 06:12:26 -0500
Message-ID: <4B601F98.6010708@cs.helsinki.fi>
Date: Wed, 27 Jan 2010 13:12:24 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Chris Wilson <chris@chris-wilson.co.uk>,
       Roman Jarosz <kedgedev@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
       A Rojas <nqn1976list@gmail.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       "A. Boulan" <arnaud.boulan@libertysurf.fr>, michael@reinelt.co.at,
       jcnengel@googlemail.com, rientjes@google.com, earny@net4u.de,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: OOM-Killer kills too much with 2.6.32.2
References: <2f11576a1001260503o5f987512n3c39ae1c3caa43f3@mail.gmail.com>  <89khjo$egh4fr@orsmga002.jf.intel.com>  <20100127091903.6AD5.A69D9226@jp.fujitsu.com> <84144f021001270156x7613c8b1ha0084b0abf604775@mail.gmail.com> <alpine.LFD.2.00.1001270252290.24253@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1001270252290.24253@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Linus Torvalds kirjoitti:
> On Wed, 27 Jan 2010, Pekka Enberg wrote:
>> Yes, we're very late in 2.6.33 cycle. Chris/Jesse, please apply
>> Motohiro-san's patch or revert the commit.
> 
> I assume you're talking about reverting commit 07f73f691 ("drm/i915: 
> Improve behaviour under memory pressure").

Yup.

> Motohiro-san's patch didn't have a sign-off or a commit message. I guess I 
> could cobble some commit message together from the thread, but it would be 
> good if somebody involved with the code were to do so. Please?

I wasn't involved with the actual patch so I'll just let Motohiro-san, 
Chris, or Jesse handle that.

			Pekka
