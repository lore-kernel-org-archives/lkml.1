Return-Path: <linux-kernel-owner+w=401wt.eu-S1755005AbZEERUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005AbZEERUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 13:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbZEERUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 13:20:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52621 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810AbZEERUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 13:20:31 -0400
Message-ID: <4A00759D.3070806@suse.de>
Date: Wed, 06 May 2009 01:21:33 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
Cc: David Daney <ddaney@caviumnetworks.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 5/7] mips cavium-octeon: add parameter to	octeon_cvmcount_read()
References: <49EF6A9E.6080605@suse.de> <49EF7F34.9040401@caviumnetworks.com> <20090505161321.GA17945@linux-mips.org>
In-Reply-To: <20090505161321.GA17945@linux-mips.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ralf Baechle Wrote:
> On Wed, Apr 22, 2009 at 01:33:56PM -0700, David Daney wrote:
> 
>> Coly Li wrote:
>>> This patch modifies parameter of octeon_cvmcount_read() from 'void' to 'struct
>>> clocksource *cs', which fixes compile warning for incompatible parameter type.
>>>
>>> Signed-off-by: Coly Li <coly.li@suse.de>
>>> Cc: David Daney <ddaney@caviumnetworks.com>
>>> Cc: Ingo Molnar <mingo@elte.hu>
>> It looks good to me:
>>
>> Reviewed-by: David Daney <ddaney@caviumnetworks.com>
> 
> Applied, thanks.
> 
> Coly, if you modify MIPS code, please cc the linux-mips mailing list and
> myself or generally consult the MAINTAINERS file for who to cc on patches.
> 
Ralf, I keep you advice in mind. Thanks.

-- 
Coly Li
SuSE Labs
