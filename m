Return-Path: <linux-kernel-owner+w=401wt.eu-S1754135AbZHONOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbZHONOT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 09:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753584AbZHONOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 09:14:18 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:46212 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbZHONOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 09:14:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Opw0CLTPfsk9xEeZjArc3shTTfr4DwFozxu65pNgRSm4k5JWITw6teIiFUq1BA7Ip+
         t64BgWpD2mnnP4dFfNdsEJAU8GARVNyKCc82jphWMCsdbTBJNgEQNY5nCad/g+h4yi7I
         YGCim8o0jYGt92y9VczOIcJS4D++Zj4zcSEIc=
Message-ID: <4A86B4A8.9040407@gmail.com>
Date: Sat, 15 Aug 2009 15:14:16 +0200
From: Niel Lambrechts <niel.lambrechts@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Knut Petersen <Knut_Petersen@t-online.de>
CC: "linux.kernel" <linux-kernel@vger.kernel.org>
Subject: Re: drm / i915 performance problems
References: <d938Z-60e-13@gated-at.bofh.it> <d93st-6q2-39@gated-at.bofh.it> <d95kz-13U-33@gated-at.bofh.it> <d95DT-1K5-17@gated-at.bofh.it> <d9cch-3A1-13@gated-at.bofh.it>
In-Reply-To: <d9cch-3A1-13@gated-at.bofh.it>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2009 11:10 PM, Knut Petersen wrote:
> Fabio Comolli schrieb:
>> If I remember correctly the solution was to add this repository:
>>
>>      http://download.opensuse.org/repositories/X11:/XOrg/openSUSE_11.1/
>>
>> to the repository list and then perform an update. Sorry but I left
>> Opensuse some months ago and my memory isn't helping a lot...
>>
>> Hope this helps. Regards,
>> Fabio
>>
>>
> No, it does not help too much. I  updated to the  software provided there
> and the result is a X  server that crashes during startup ... :-(

I'm also a former OPENSUSE user and I also used the repository above, and had best success when I updated the packages by going into the view for the repository itself.

Perhaps try selecting the packages like that and also make sure you update all the DRM and Mesa packages.

Hope this helps.

Niel
