Return-Path: <linux-kernel-owner+w=401wt.eu-S1753184AbXIAIhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbXIAIhZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 04:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbXIAIhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 04:37:13 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:5921 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbXIAIhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 04:37:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=QIBGBw6BREa3pjJNRiYWGIilJ8j6GaJvpjLon3E8Pq8TlYPZUQVz5H8VgWAhDgTkki1z+8MFAUDcCAdBwuvmPFyKZNwr8wndzlJdfXXuWwxA97jleMwh8mEzowa6CKtmfS0y69h1J2wCPiJ5Sy/fxAeEoEXpeZH1NphAFmmqWks=
Message-ID: <46D924A3.3070207@googlemail.com>
Date: Sat, 01 Sep 2007 10:36:51 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
       linux-acpi@vger.kernel.org, Alexey Starikovskiy <astarikovskiy@suse.de>,
       Daniel Ritz <daniel.ritz-ml@swissonline.ch>
Subject: Re: [1/2] 2.6.23-rc3: known regressions with patches
References: <46D59081.2040605@googlemail.com> <200708311741.22863.lenb@kernel.org>
In-Reply-To: <200708311741.22863.lenb@kernel.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown pisze:
> On Wednesday 29 August 2007 11:28, Michal Piotrowski wrote:
> 
>> ACPI
>>
>> Subject         : the fan doesn't work any more
>> References      : http://lkml.org/lkml/2007/8/28/359
>> Last known good : ?
>> Submitter       : Daniel Ritz <daniel.ritz-ml@swissonline.ch>
>> Caused-By       : Alexey Starikovskiy <astarikovskiy@suse.de>
>>                   commit cd8c93a4e04dce8f00d1ef3a476aac8bd65ae40b
>> Handled-By      : Alexey Starikovskiy <astarikovskiy@suse.de>
>> Patch           : http://lkml.org/lkml/2007/8/29/15
>> Status          : patch was suggested
> 
> I believe that this is gone as of 2.6.23-rc4-git3
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=8958

BTW. Maciej Rutecki has said that "MCFG bug on hp nx6310" is not
a regression, so regression counter for ACPI == 0 (if I didn't
overlook something :))

> 
> thanks,
> -Len
> 

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
