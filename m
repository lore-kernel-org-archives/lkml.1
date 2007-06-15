Return-Path: <linux-kernel-owner+w=401wt.eu-S1758745AbXFOVUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758745AbXFOVUV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 17:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755562AbXFOVUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 17:20:10 -0400
Received: from cb2.northrockquote.com ([64.251.14.146]:2641 "EHLO
	dejavu.debianpt.org" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756212AbXFOVUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 17:20:08 -0400
Message-ID: <4673026F.8070406@debianpt.org>
Date: Fri, 15 Jun 2007 22:19:43 +0100
From: Miguel Figueiredo <elmig@debianpt.org>
Organization: DebianPT.org
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: ck@vds.kolivas.org,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: call for more SD versus CFS comparisons (was: Re: [ck] Mainline
 plans)
References: <466DE921.9030709@debianpt.org>	(sfid-20070612_171838_254605_20164719) <200706121852.58161.Martin@lichtvoll.de>
In-Reply-To: <200706121852.58161.Martin@lichtvoll.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Steigerwald wrote:
> Am Dienstag 12 Juni 2007 schrieb Miguel Figueiredo:
>> Hi all,
>>
>> some results based on massing_intr.c by Satoru, can be found on
>> http://people.redhat.com/mingo/cfs-scheduler/tools/massive_intr.c
> 
> Hi Miquel, Ingo, Con!
> 
[...]

> Any suggestions?

I read somewhere in the list that X itself makes lots of hocus pocus
that affect the behavior of programs running inside X itself (i even
read about X's own scheduling - someone can confirm/deny it? - and evil
behavior on drivers).

If we look/test a fair/responsive scheduler isn't better to test it
outside X?
IMHO, X itself, it's too complex and may obscure our tests on
fairness/interactivity.

Anyone knows any good tests for interctivity?

[...]

-- 

Com os melhores cumprimentos/Best regards,

Miguel Figueiredo
http://www.DebianPT.org
