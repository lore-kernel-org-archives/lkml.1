Return-Path: <linux-kernel-owner+w=401wt.eu-S1753774AbYCMArI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774AbYCMArI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 20:47:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbYCMAq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 20:46:56 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:49961 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbYCMAqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 20:46:55 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5250"; a="1073192"
Message-ID: <47D8797D.4020307@qualcomm.com>
Date: Wed, 12 Mar 2008 17:46:53 -0700
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: menage@google.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org
Subject: Re: boot cgroup questions
References: <47D73086.2030008@qualcomm.com>	<6599ad830803111827n1cb8e2c7i47c2ef3f3bb58995@mail.gmail.com>	<47D7411E.1000009@qualcomm.com>	<6599ad830803111936jd940deam8584bc971c3b6f41@mail.gmail.com>	<47D74595.4080100@qualcomm.com>	<6599ad830803112009y18d9e43ft8e3fc4a551d891da@mail.gmail.com>	<20080311235939.1ebee8e3.pj@sgi.com>	<47D81FE1.6030205@qualcomm.com>	<20080312135746.89456f2a.pj@sgi.com>	<47D82AD2.1070108@qualcomm.com>	<20080312143253.3dd72c7f.pj@sgi.com>	<47D83858.4030806@qualcomm.com>	<20080312153712.bc5df7a1.pj@sgi.com>	<47D8593A.6040503@qualcomm.com> <20080312183210.33f3910c.pj@sgi.com>
In-Reply-To: <20080312183210.33f3910c.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Max K wrote:
>> 1. use simple "irq == pseudo-task" concept and potentially brake some existing 
>> software. We do have working solution.
> 
> Breaking existing software is not what I call working.
> 
Ok ok I get it :)
You know what I meant though. In the other scheme it's not even clear how it'd 
work in general.

Max


