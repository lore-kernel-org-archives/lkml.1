Return-Path: <linux-kernel-owner+w=401wt.eu-S1761720AbXHAJ4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761720AbXHAJ4V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 05:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761368AbXHAJzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 05:55:52 -0400
Received: from gepetto.dc.ltu.se ([130.240.42.40]:46829 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760449AbXHAJzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 05:55:50 -0400
X-Greylist: delayed 1007 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Aug 2007 05:55:48 EDT
Message-ID: <46AF255A.4050106@student.ltu.se>
Date: Tue, 31 Jul 2007 14:04:42 +0200
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: Robin Getz <rgetz@blackfin.uclinux.org>,
       Yoann Padioleau <padator@wanadoo.fr>,
       David Howells <dhowells@redhat.com>, kernel-janitors@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/68] 0 -> NULL, for arch/frv
References: <200707270944.LAA17167@ifs.emn.fr> <22618.1185531297@redhat.com>	 <87lkd29mk9.fsf@wanadoo.fr>	 <200707272138.23323.rgetz@blackfin.uclinux.org> <8bd0f97a0707271837q5d5f31d9pe342e72ebf9368c1@mail.gmail.com>
In-Reply-To: <8bd0f97a0707271837q5d5f31d9pe342e72ebf9368c1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> On 7/27/07, Robin Getz <rgetz@blackfin.uclinux.org> wrote:
>   
>> If there is a definite style or semantic preference that everyone should live
>> with - does it make sense to put checks in checkpatch.pl to enforce it?
>>     
>
> checkpatch.pl does not have enough semantic knowledge to know if the
> thing being tested is a pointer ... dont know if the sparse utility
> would be able to pick it out as i'm not familiar with what level that
> thing runs at
>   
Didn't he mean "x == NULL" > "!x"?

Richard Knutsson
(wrote this offline so if someone has already reply, then sorry about 
the noise)


