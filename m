Return-Path: <linux-kernel-owner+w=401wt.eu-S1752499AbZHaOo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499AbZHaOo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 10:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbZHaOoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 10:44:25 -0400
Received: from mx1.utsp.utwente.nl ([130.89.2.12]:50883 "EHLO mx.utwente.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834AbZHaOoZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 10:44:25 -0400
X-Greylist: delayed 2924 seconds by postgrey-1.27 at vger.kernel.org; Mon, 31 Aug 2009 10:44:24 EDT
Subject: Re: [PATCH 00/18] OMAP: DSS2: Intro
Mime-Version: 1.0 (Apple Message framework v1075.2)
Content-Type: text/plain; charset=iso-8859-1; format=flowed; delsp=yes
From: Koen Kooi <k.kooi@student.utwente.nl>
In-Reply-To: <4A9B96A7.5040005@gmail.com>
Date: Mon, 31 Aug 2009 15:54:20 +0200
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Tony Lindgren <tony@atomide.com>,
       Tomi Valkeinen <tomi.valkeinen@nokia.com>, linux-kernel@vger.kernel.org,
       "linux-omap@vger.kernel.org Mailing List" 
	<linux-omap@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <33395592-242E-475A-9642-2AFD5B478B81@student.utwente.nl>
References: <1251462337-12531-1-git-send-email-tomi.valkeinen@nokia.com> <4A9B96A7.5040005@gmail.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
X-Mailer: Apple Mail (2.1075.2)
X-UTwente-MailScanner-Information: Scanned by MailScanner. Contact icts.servicedesk@utwente.nl for more information.
X-UTwente-MailScanner: Found to be clean
X-UTwente-MailScanner-From: k.kooi@student.utwente.nl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Op 31 aug 2009, om 11:23 heeft Artem Bityutskiy het volgende geschreven:

> On 08/28/2009 03:25 PM, Tomi Valkeinen wrote:
>> This patch set implement new display subsystem driver (DSS2) and  
>> omapfb driver
>> for OMAP2/3. The patches have been reviewed on linux-omap and linux- 
>> fbdev-devel
>> mailing lists. The patches can also be found from
>> http://gitorious.org/linux-omap-dss2/linux
>>
>> The patches include DSS documentation patch that includes more  
>> instructions for
>> module parameters, sysfs files etc.
>>
>> The patches enable DSS2 for OMAP3430 SDP board. DSS2 is used in  
>> various boards,
>> for example Nokia N900, Beagle Board and Overo.
>>
>> I don't currently have any OMAP2 board to test DSS2, but it has  
>> worked on OMAP2
>> and the possible fixes needed should be minimal.
>>
>> OMAP1 is not supported, and so the old DSS needs to be used on  
>> OMAP1 boards.
>>
>> DSS2 is partly based on the old omapfb driver by Imre Deak, and  
>> Imre has also
>> contributed to DSS2 quite a bit. Ville Syrjälä has been  
>> contributing to scaling
>> and tv-out work. Also some contributions have been made by Hardik  
>> Shah, Vaibhav
>> Hiremath, and perhaps some others that I have forgotten =).
>
> Tony, Andrew,
>
> how could we merge this code (unless there are requests to change  
> something, which
> does not seem to be the case.). It seems like there is no maintainer  
> who could
> merge this. Or there is? Would Tomi need to send a direct pull  
> request to Linus,
> or this could got via Tony?
>
> We are using DSS2 in Nokia for about a year already. N900 is using  
> this
> code, for example. Other (non-Nokia) projects are using DSS2 as well.
> The code was public for long time and was sent several times for  
> review.

With my beagleboard hat on: I agree with Artem, let's get this merged.  
I hope other TI folk can put their TI hat on and say something nice  
about dss2 as well :)

regards,

Koen

