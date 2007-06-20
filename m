Return-Path: <linux-kernel-owner+w=401wt.eu-S1753499AbXFTWcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbXFTWcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 18:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750763AbXFTWc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 18:32:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52888 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753AbXFTWc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 18:32:27 -0400
Message-ID: <4679AAD5.4030604@redhat.com>
Date: Wed, 20 Jun 2007 18:31:49 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Ian McDonald <ian.mcdonald@jandi.co.nz>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Ingo Molnar <mingo@elte.hu>, "Darrick J. Wong" <djwong@us.ibm.com>,
       Andi Kleen <ak@suse.de>,
       =?ISO-8859-1?Q?Bj=F6rn_Steinbrink?= <B.Steinbrink@gmx.de>,
       William Cohen <wcohen@redhat.com>,
       "S. P. Prasanna" <prasanna@in.ibm.com>,
       Antonino Daplas <adaplas@gmail.com>, Olaf Hering <olaf@aepfle.de>,
       =?ISO-8859-1?Q?Ville_Syrj=E4l=E4?= <syrjala@sci.fi>,
       Jean Delvare <khali@linux-fr.org>, Rudolf Marek <r.marek@assembler.cz>,
       Soeren Sonnenburg <kernel@nn7.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [1/2] 2.6.22-rc5: known regressions with patches
References: <467543FA.60905@googlemail.com> <5640c7e00706201508g3c1fc40eq82a1db05c9156b5d@mail.gmail.com>
In-Reply-To: <5640c7e00706201508g3c1fc40eq82a1db05c9156b5d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2007 06:08 PM, Ian McDonald wrote:
> Andrew,
> 
> Can this one be merged so that it makes it into 2.6.22?
> 
>>
>> Subject    : CONFIG_DEBUG_RODATA prevents kprobes from working on
>> 2.6.22-rc2
>> References : http://lkml.org/lkml/2007/5/23/202
>> Submitter  : William Cohen <wcohen@redhat.com>
>>              Ian McDonald <ian.mcdonald@jandi.co.nz>
>> Handled-By : S. P. Prasanna <prasanna@in.ibm.com>
>> Patch      : http://lkml.org/lkml/2007/6/7/2
>> Status     : patch available

Patch was just merged:

http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=55181000cd60334fe920c65ffbcdfe0e3f1de406
