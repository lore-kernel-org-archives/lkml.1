Return-Path: <linux-kernel-owner+w=401wt.eu-S1765322AbXHWUJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765322AbXHWUJE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 16:09:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756378AbXHWUIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 16:08:55 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:59559 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434AbXHWUIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 16:08:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=jl0Q+MKs7KGLfabWbac+qBcxKjOPlis/330dy7H0y94ldLPalK9O/bsbWwrDR5/8OqvOYK0A6+zFIOmKsuB7zvaK0l6nmwHyb8dIRH2OToB5F/XHyDy51GmPLPEA5ui6P7JOw6OhIBbn0YRZVTJ3al+D/KL8S85c4reA8PDT4LI=
Message-ID: <46CDE94A.7000600@googlemail.com>
Date: Thu, 23 Aug 2007 22:08:42 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Daniel Walker <dwalker@mvista.com>
CC: =?UTF-8?B?QmrDtnJuIFN0ZWluYnJpbms=?= <B.Steinbrink@gmx.de>,
       eranian@hpl.hp.com, ak@suse.de, linux-kernel@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: nmi_watchdog=2 regression in 2.6.21
References: <1186531609.22044.50.camel@imap.mvista.com>	 <20070808142059.GF30805@atjola.homenet> <1187628296.7732.14.camel@imap.mvista.com>
In-Reply-To: <1187628296.7732.14.camel@imap.mvista.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

Daniel Walker pisze:
> On Wed, 2007-08-08 at 16:20 +0200, Björn Steinbrink wrote:
>> On 2007.08.07 17:06:49 -0700, Daniel Walker wrote:
>>> This patch below hangs my system on boot if I set nmi_watchdog=2 . It
>>> shows the NMI as stuck then the system hangs .. nmi_watchdog=1 works
>>> fine, and the system boots without any watchdog options ..
>>>
>>> The machine is an Intel allagash development board, and it has two dual
>>> core Pentium-M cpus. I attached the .config I used.
> 
> Could we put this on the known regressions list? It was added in 2.6.21,
> and still exists in lastest git (as of 15 min. ago) ..

Bugzilla should be a better place for this bug.

I don't have enough time to track bugs after release, so old lists are not
maintained
http://kernelnewbies.org/known_regressions_2622
http://kernelnewbies.org/known_regressions_2621

> 
> Daniel
> 
> 

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
