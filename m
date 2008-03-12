Return-Path: <linux-kernel-owner+w=401wt.eu-S1753811AbYCLTbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbYCLTbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 15:31:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbYCLTa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 15:30:56 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15325 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbYCLTaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 15:30:55 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5250"; a="1065150"
Message-ID: <47D82F6D.2000801@qualcomm.com>
Date: Wed, 12 Mar 2008 12:30:53 -0700
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: Paul Menage <menage@google.com>, mingo@elte.hu, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org
Subject: Re: boot cgroup questions
References: <47D73086.2030008@qualcomm.com>	<6599ad830803111827n1cb8e2c7i47c2ef3f3bb58995@mail.gmail.com>	<47D7411E.1000009@qualcomm.com>	<6599ad830803111936jd940deam8584bc971c3b6f41@mail.gmail.com>	<47D74595.4080100@qualcomm.com>	<6599ad830803112009y18d9e43ft8e3fc4a551d891da@mail.gmail.com>	<20080311235939.1ebee8e3.pj@sgi.com>	<6599ad830803121216y32b88d15r462aac437142d814@mail.gmail.com> <20080312142414.71c5731f.pj@sgi.com>
In-Reply-To: <20080312142414.71c5731f.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Paul M wrote:
>> Not cgroups, no. If you really wanted to extend cpusets specifically
>> to allow irqs to be assigned to a cpuset to control which cpus they
>> could execute on, then that might be a possibility. But I don't see
>> how this would be useful for any other cgroup subsystem, so it doesn't
>> belong in the generic framework.
> 
> Ok - a sensible decision.
> 
>> My feeling is that just using a simple bitmask assignment, unrelated
>> to cpusets or cgroups, as Max suggested in his later email is the way
>> to go.
> 
> I'll have to have another go at reading his replies.  I seem to have
> more difficulty making sense of his posts ... not sure why.
I'm sure it's because of gazillion typos in them :).

Max
