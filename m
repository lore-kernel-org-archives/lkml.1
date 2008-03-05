Return-Path: <linux-kernel-owner+w=401wt.eu-S1756458AbYCEK7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458AbYCEK7y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 05:59:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750740AbYCEK7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 05:59:44 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:22629 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbYCEK7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 05:59:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=vjqeu1idSOWAtPhBl+vZRyD8QUYJY++14/21FRzRc6djV69ZYvKqPATAgnEX2Vs5FVZMyzqsxNp4uzHsoT/bv5/FYTsMmeCWR4e9Zy+TBV1axP/4RP5UYYpsjm/GNXrfPSyE4Tc9Gzw173P06o6m8mSga+ZBtBpT/0NyJnzfIUM=
Message-ID: <47CE7D18.8090308@gmail.com>
Date: Wed, 05 Mar 2008 11:59:36 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Andrew G. Morgan" <morgan@kernel.org>, Serge Hallyn <serue@us.ibm.com>,
       James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Paul Moore <paul.moore@hp.com>
Subject: Re: prctl(0x8) -> EINVAL [Was: 2.6.25-rc3-mm1]
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org> <47CE7B1F.3000208@gmail.com>
In-Reply-To: <47CE7B1F.3000208@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2008 11:51 AM, Jiri Slaby wrote:
> On 03/04/2008 10:19 AM, Andrew Morton wrote:
>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc3/2.6.25-rc3-mm1/ 
>>
>> +capabilities-implement-per-process-securebits.patch
> 
> This probably causes userspace damage:

sorry, s/probably//
