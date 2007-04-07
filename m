Return-Path: <linux-kernel-owner+w=401wt.eu-S966342AbXDGUcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966342AbXDGUcH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 16:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966343AbXDGUcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 16:32:07 -0400
Received: from vms040pub.verizon.net ([206.46.252.40]:58588 "EHLO
	vms040pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966342AbXDGUcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 16:32:05 -0400
Date: Sat, 07 Apr 2007 16:31:44 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Ten percent test
In-reply-to: <1175973261.6288.2.camel@Homer.simpson.net>
To: linux-kernel@vger.kernel.org
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       Con Kolivas <kernel@kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
Message-id: <200704071631.44371.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200703290237.38777.kernel@kolivas.org>
 <20070407180818.GB23861@elte.hu> <1175973261.6288.2.camel@Homer.simpson.net>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 07 April 2007, Mike Galbraith wrote:
>On Sat, 2007-04-07 at 20:08 +0200, Ingo Molnar wrote:
>> * Gene Heskett <gene.heskett@gmail.com> wrote:
>> > (who the hell runs a 'make -j 200' or 50 while(1)'s in the real
>> > world?
>>
>> not many - and i dont think Mike tested any of these - Mike tested
>> pretty low make -j values (Mike, can you confirm?).
>
>Yes.  I don't test anything more than make -j5 when looking at
>interactivity, and make -j nr_cpus+1 is my must have yardstick.
>
>	-Mike

Somebody made that remark, maybe not you, and maybe they were being funny, 
but I didn't at the time, see any smileys.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Please remain calm, it's no use both of us being hysterical at the same 
time.
