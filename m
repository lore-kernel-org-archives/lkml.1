Return-Path: <linux-kernel-owner+w=401wt.eu-S1757964AbXISWjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964AbXISWjV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 18:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbXISWjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 18:39:13 -0400
Received: from free-electrons.com ([88.191.23.47]:50294 "EHLO
	sd-2511.dedibox.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbXISWjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 18:39:13 -0400
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Sep 2007 18:39:12 EDT
Message-ID: <46F1A4FF.6040808@free-electrons.com>
Date: Thu, 20 Sep 2007 00:38:55 +0200
From: Michael Opdenacker <michael@free-electrons.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Tim Bird <tim.bird@am.sony.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       linux-tiny <Linux-tiny@selenic.com>,
       CE Linux Developers List <celinux-dev@tree.celinuxforum.org>
Subject: Re: [Celinux-dev] [Announce] Linux-tiny project revival
References: <46F1645D.9050406@am.sony.com> <20070919142805.e0242fcf.akpm@linux-foundation.org> <46F19778.7000408@am.sony.com>
In-Reply-To: <46F19778.7000408@am.sony.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Bird wrote:
> Andrew Morton wrote:
>   
>> On Wed, 19 Sep 2007 11:03:09 -0700
>> Tim Bird <tim.bird@am.sony.com> wrote:
>>
>>     
>>> Recently, the CE Linux forum has been working to revive the
>>> Linux-tiny project.  At OLS, I asked for interested parties
>>> to volunteer to become the new maintainer for the Linux-tiny patchset.
>>>       
>> I volunteer!  Send patches to me, cc linux-kernel and celinuv-dev.
>>
>> Seriously, putting this stuff into some private patch collection should
>> be a complete last resort - you should only do this with patches which
>> you (and the rest of us) agree have no hope of ever getting into mainline.
>>     
>
> OK, I'll try to accelerate the effort to send these to you.
> We'll still need some kind of bucket for the patches that
> don't apply to recent kernels, but which no one has yet
> had time to bring up-to-date (or evaluate for permanent
> dismissal).  And dribbling them out, fixing them up,
> responding to issues - all take time that I can't
> commit to personally for the next week or so.
> I'll let Michael respond whether he can get to this
> sooner rather than later, as planned.
>   

Andrew, you're completely right... The patches should all aim at being
included into mainline or die.

I'm finishing a sequence of crazy weeks and I will have time to send you
patches one by one next week, starting with the easiest ones.

Thanks for your support.

Cheers,

Michael.

-- 
Michael Opdenacker
http://free-electrons.com
+33 621 604 642

