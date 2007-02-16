Return-Path: <linux-kernel-owner+w=401wt.eu-S1422878AbXBPAgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422878AbXBPAgh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 19:36:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422891AbXBPAgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 19:36:37 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:34967 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422878AbXBPAgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 19:36:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VyfRYtPacVxtXETKgtfVEo8qiN/FfdVlLZETOAcR33El8Np04+iRGuOarHKz245qsGxqHNn791zAZvw4pNVvLsHFG1tOr45xbooRjFBiUref6zSmeJRKzpw3UL20mtJTcOApnBd3cDsbMghhKB50O6e+vqMNLtXInFrw3njcSvU=
Message-ID: <7b69d1470702151636y243919c0n5307eaf7d20499c2@mail.gmail.com>
Date: Thu, 15 Feb 2007 18:36:33 -0600
From: "Scott Preece" <sepreece@gmail.com>
To: "Stuart MacDonald" <stuartm@connecttech.com>
Subject: Re: GPL vs non-GPL device drivers
Cc: "v j" <vj.linux@gmail.com>, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Dave Jones" <davej@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <000001c7511d$829e91c0$294b82ce@stuartm>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9b3a62ab0702142328h87365b6i932d4f2c117f7f0e@mail.gmail.com>
	 <000001c7511d$829e91c0$294b82ce@stuartm>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/15/07, Stuart MacDonald <stuartm@connecttech.com> wrote:

> Linus does allow for one exception; drivers written for other OSes
> that happen to compile for Linux as well. I believe this is the POSIX
> exception mentioned elsethread. However, from your description of
> requiring GPL-only symbols, I'm pretty sure your driver is a derived
> work. Since you're distributing it (inside your device), the code must
> be made available, under the GPL.
---

It really is legally unclear. There is substantial case law that
supports the idea that interfacing for interoperability does not
create a derived work. I agree that it's uncivil to ignore the
author's intentions, but I think that it's very unclear whether it's
"illegal". The company I work for has made the choice to avoid the
question and ship only GPL kernel modules, which seems like the right
answer to me.

---
>
> You also asserted that the code is only useful to your competitors.
> That simply is not true. No company suppports a product forever, even
> if they believe they will. Once that support is gone, the only way to
> fix bugs or improve the product is to **have the code in hand**. THAT
> is what the GPL-openness is all about. THAT is when the code is useful
> to the open source community at large. Since that need is inevitable,
> the code must be provided up-front, when distribution starts.
---

Note that it is possible that what vj said is strictly true. IF the
product they ship is non-modifiable, then it's hard to argue that
anyone else could maintain it. And if the drivers are for devices
proprietary to their hardware, then they have no real value to anyone
else. And the drivers MIGHT contain information useful to their actual
competitors. I have no knowledge as to whether those conditions
actually apply.

scott
