Return-Path: <linux-kernel-owner+w=401wt.eu-S1751351AbXAXT1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351AbXAXT1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 14:27:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbXAXT1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 14:27:50 -0500
Received: from server077.de-nserver.de ([62.27.12.245]:43315 "EHLO
	server077.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbXAXT1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 14:27:49 -0500
Message-ID: <45B7B334.2050904@profihost.com>
Date: Wed, 24 Jan 2007 20:27:48 +0100
From: Stefan Priebe - FH <studium@profihost.com>
User-Agent: Mozilla Thunderbird 1.0.7 (Windows/20050923)
X-Accept-Language: de-DE, de, en-us, en
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: linux-kernel@vger.kernel.org, edmudama@gmail.com
Subject: Re: XFS or Kernel Problem / Bug
References: <20060801141545.B2326184@wobbly.melbourne.sgi.com> <44CED76B.20507@profihost.com> <20060801142755.C2326184@wobbly.melbourne.sgi.com> <44CED8F4.9080208@profihost.com> <20060801143212.D2326184@wobbly.melbourne.sgi.com> <44CEDA1D.5060607@profihost.com> <20060801143803.E2326184@wobbly.melbourne.sgi.com> <44CF36FB.6070606@profihost.com> <20060802090915.C2344877@wobbly.melbourne.sgi.com> <44D07AB7.3020409@profihost.com> <20060802201805.A2360409@wobbly.melbourne.sgi.com> <45B35CD7.4080801@profihost.com> <45B666BE.8000802@redhat.com> <45B70D69.20500@profihost.com> <45B773C1.7090805@redhat.com> <45B77547.4060302@profihost.com> <45B77780.5000504@redhat.com> <45B77C84.6070508@profihost.com> <45B78E9F.4000404@redhat.com> <45B7948B.70104@profihost.com> <45B79DCF.4040904@redhat.com>
In-Reply-To: <45B79DCF.4040904@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by hostmaster@profihost.com through 84.133.203.160
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chuck,
    hi Eric,

cause you both asked me nearly the same i will answer you both in one mail.


 > What is different about these servers?
All 300 machines are mostly different. We have Dual Opteron, single P4 
with HT, single P4 without HT, Dual Xeon, Athlon 64 X2, and many more... 
different mainboards etc.

The only thing i found out is, that all these servers (where the problem 
exist) are using a DFI PM-12 Mainboard with a VIA Chipset.

 > Are you building different kernels for them, or is it just different
 > drivers loaded?
No every machine builds it's own kernel.

Stefan

Chuck Ebbert schrieb:
> Stefan Priebe - FH wrote:
> 
>>Hi!
>>
>>Mhm are you shure? I mean i have this problem on 5 servers - all with
>>the same mainboard. I cannot believe, that all 5 servers have a
>>hardware problem that starts on the same day.
>>
>>The other thing is - that they all work fine with 2.6.16.x and all
>>other kernels before. I mean some of them were used with 2.6.x since
>>two years without any problem...
>>
> 
> OK it's probably not hardware, but a bit is flipped somehow.
> 
> What is different about these servers?
> 
> Are you building different kernels for them, or is it just different
> drivers loaded?
> 
> 

