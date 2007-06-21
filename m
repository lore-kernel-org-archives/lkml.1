Return-Path: <linux-kernel-owner+w=401wt.eu-S1755869AbXFUDGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbXFUDGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 23:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752971AbXFUDGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 23:06:09 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:56043
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbXFUDGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 23:06:07 -0400
Date: Wed, 20 Jun 2007 20:06:17 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Michael Poole <mdpoole@troilus.org>
cc: davids@webmaster.com, linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <87ejk6qbco.fsf@graviton.dyn.troilus.org>
Message-ID: <Pine.LNX.4.64.0706201959110.31603@asgard.lang.hm>
References: <MDEHLPKNGKAHNMBLJOLKGEDMEMAC.davids@webmaster.com>
 <87ejk6qbco.fsf@graviton.dyn.troilus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2007, Michael Poole wrote:

> David Schwartz writes:
>
>>> However, compilations (even to the extent they are creative
>>> combinations) are not necessarily derivative works of their elements.
>>> For more details, see
>>> http://www.copyright.gov/circs/circ14.html#compilations
>>
>> Because compilation copyrights don't really affect the Tivo and GPLv2/GPLv3
>> issue, I tend to ignore them when discussing that subject. If you think I'm
>> wrong and there is some relationship between them, please let me know. I
>> admit I may not have given that possibility enough thought.
>
> I believe compilation copyrights do bear on GPL-licensed software, by
> virtue of the GPL's sentence "[...] rather, the intent is to exercise
> the right to control the distribution of derivative _or collective_
> works based on the Program." (emphasis added).
>
> There is a lot of grey and/or arguable area about what constitutes a
> GPL-encumbered collective work versus mere aggregation.  Although I
> disagree, I understand and respect that some believe that the kernel
> plus a digital signature over it is "mere aggregation".  I would like
> to focus the discussion on that question, though, rather than whether
> the GPL is worded to control the rights to compilations-in-general
> that include GPLed works.

if the GPL can excercise control over compilations, then if Oracle were to 
ship a Oracle Linux live CD that contained the Oracle Database in the 
filesystem image, ready to run. then the GPL would be able to control the 
Oracle Database code.

if the GPL can't do this then it can't control the checksum either.

again, it's not just the kernel that's part of the checksum on a tivo, the 
checksum is over the kernel + initial filesystem, much of which contains 
code not covered by the gPL)

David Lang
