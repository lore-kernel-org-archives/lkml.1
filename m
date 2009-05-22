Return-Path: <linux-kernel-owner+w=401wt.eu-S1751927AbZEVEgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbZEVEgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 00:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750976AbZEVEgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 00:36:06 -0400
Received: from smtp106.prem.mail.sp1.yahoo.com ([98.136.44.61]:27684 "HELO
	smtp106.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750851AbZEVEgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 00:36:05 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: P6.xmpgVM1k3nlWqyMNx.8DSfOtA9X.Ux_hIqnYNuSsfninLXnM9GQ9AzAq6HUl0r.UO.1Gw3qdYX3Qkx13I4bgCZYA7oVC.5fD8mX58oqHg8.cUDkYktq8nTlHWqGHi30wnFZG7o8alnvkbwepBsA6bo.zkg3SLAFhZjNrp6Uxn_v1hT1QbYIOTbY.XMpnIJc7rVPii7tpR_ux5QZb4Lbj3m3D8zT_8tRpdXYh.0KgyxaOy1QuZ2B2uW66602Nr9ZcK4iy4G5uvjtKu0o7qVcbxkhYKoPge6LFPjvEMS7sHnvxCMvGQ8_bcbE..Y7AkQqLs6WK9py_p0n2adn0-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4A162B9E.7000003@schaufler-ca.com>
Date: Thu, 21 May 2009 21:35:42 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: Roel Kluin <roel.kluin@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] smack:beyond ARRAY_SIZE of data
References: <4A141F83.10102@gmail.com> <4A1483E0.1030303@schaufler-ca.com> <4A15848E.5030403@gmail.com> <4A160E28.1010306@schaufler-ca.com> <alpine.LRH.2.00.0905221235530.7391@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.0905221235530.7391@tundra.namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris wrote:
> On Thu, 21 May 2009, Casey Schaufler wrote:
>
>   
>> Roel Kluin wrote:
>>     
>>> Do not go beyond ARRAY_SIZE of data
>>>
>>> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
>>>   
>>>       
>> Acked-by: Casey Schaufler <casey@schaufler-ca.com>
>>
>> Thank you. The fix is appreciated.
>>
>>     
>
> Applied to
> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next
>
> (This needs CAP_MAC_ADMIN to trigger, so I'll assume this is not 
> security-critical, but yell if you disagree).
>
>   

Not security critical.

> - James
>   
