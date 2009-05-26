Return-Path: <linux-kernel-owner+w=401wt.eu-S1757584AbZEZWky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584AbZEZWky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 18:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757064AbZEZWko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 18:40:44 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:47829 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756459AbZEZWkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 18:40:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:x-accept-language:mime-version:to
         :cc:subject:references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=mn6c6b8QmWsh5cy/Rl3MZofopsdcUT8OcRsKunzVQy4FlMXR4n0yUEBP0BfmiCvbJR
         42DE+ZjJ2U89rCUBoMzxajQ6vTTmGUF87KvVD8Gn02QcwiWwTsSmURDY3ltwzeGdTsF5
         W3Yq9UC2H09Ag7QmMJxW6g7HXG7T9Bn91ugqI=
Message-ID: <4A1C6FE9.1050003@googlemail.com>
Date: Wed, 27 May 2009 00:40:41 +0200
From: Michael Riepe <michael.riepe@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: de-de, de, en-us, en
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: mb@bu3sch.de, dave@thedillows.org, romieu@fr.zoreil.com,
       rsantos@grupopie.com, m.bueker@berlin.de, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 2.6.30-rc4] r8169: avoid losing MSI interrupts
References: <20090525.225503.173348268.davem@davemloft.net>	<200905262022.24593.mb@bu3sch.de>	<20090526.145211.37114439.davem@davemloft.net> <20090526.151410.109935435.davem@davemloft.net>
In-Reply-To: <20090526.151410.109935435.davem@davemloft.net>
X-Enigmail-Version: 0.91.0.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Tue, 26 May 2009 14:52:11 -0700 (PDT)
> 
> 
>>From: Michael Buesch <mb@bu3sch.de>
>>Date: Tue, 26 May 2009 20:22:23 +0200
>>
>>
>>>I didn't notice a CC:stable.
>>>I think this should also go to stable.
>>>Does somebody take care?
>>
>>I'll queue it up.
> 
> 
> Actually, this patch doesn't even remotely come close to applying
> to 2.6.29.4

Michael Buesch already provided a patch against 2.6.29.4 that we both
tested. I doubt that it will apply to 2.6.27 cleanly, though.

-- 
Michael "Tired" Riepe <michael.riepe@googlemail.com>
X-Tired: Each morning I get up I die a little
