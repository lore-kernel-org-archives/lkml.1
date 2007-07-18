Return-Path: <linux-kernel-owner+w=401wt.eu-S935668AbXGRSB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935668AbXGRSB4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 14:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935135AbXGRSBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 14:01:35 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:23643 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935057AbXGRSBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 14:01:34 -0400
Message-ID: <469E5629.4020409@oracle.com>
Date: Wed, 18 Jul 2007 11:04:25 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: 2.6.22-git* regression: Kconfig prompts without help text
References: <469BBDAD.2010908@s5r6.in-berlin.de> <Pine.LNX.4.64.0707181634100.5385@fbirervta.pbzchgretzou.qr> <20070718094119.4a26ae03.randy.dunlap@oracle.com> <Pine.LNX.4.64.0707181916410.5385@fbirervta.pbzchgretzou.qr> <20070718103456.cf32bf78.randy.dunlap@oracle.com> <Pine.LNX.4.64.0707181954190.5385@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0707181954190.5385@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Jul 18 2007 10:34, Randy Dunlap wrote:
>>> On Jul 18 2007 09:41, Randy Dunlap wrote:
>>>> Looks good to me except that help text should be indented by
>>>> 2 more spaces according to CodingStyle.
>>> Who invented that rule anyway... the "---help---" marker (note the dashes)
>>> clearly separates things already.
>>> Here you go.
>> I have no idea where it came from.  (not me)
> 
> It was akpm:
> http://linux.bkbits.net:8080/linux-2.6/Documentation/CodingStyle?PAGE=diffs&REV=1.5
> 
> Well, can we lift it?

I think that would only make sense if "---help---" is used (like you did)
instead of the plain "help" string.

In the case of "---help---", it's OK with me not to be indented by 2 more
spaces.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
