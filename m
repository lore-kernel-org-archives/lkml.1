Return-Path: <linux-kernel-owner+w=401wt.eu-S1761615AbZDHIuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761615AbZDHIuy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 04:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761221AbZDHIum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 04:50:42 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:50637 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761476AbZDHIuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 04:50:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=QXdYEm3ZOSdn8lhXp39iCRL2ywKWyLSRYFEK3Ky112XlH69QC5YEWvfS124NDskBJP
         AeXgt+/uPz62d1GGUGf4xU3IIguqTy83brlH3xDsS4waoWWgRxki8lxpzIinqvmTP/gu
         alCoJI1NGfgwZfPZW6xbLT2HGJGcR9ijWLTmc=
Message-ID: <49DC6560.1010803@gmail.com>
Date: Wed, 08 Apr 2009 10:50:40 +0200
From: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Subject: Re: kernel oops with latest git v2.6.29-9516-g0221c81
References: <49DA6168.2020701@gmail.com> <200904062234.29481.a.miskiewicz@gmail.com>
In-Reply-To: <200904062234.29481.a.miskiewicz@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arkadiusz Miskiewicz ha scritto:
> On Monday 06 of April 2009, Riccardo Magliocchetti wrote:
>> Hi,
>>
>> i've updated the kernel to latest git and now it's oopsing.
>>
>> I've uploaded 3 pictures taken from a camera here:
>>
>> http://yfrog.com/41oops1j
>> http://yfrog.com/bcoops2j
>> http://yfrog.com/bcoops3j
> 
> You hit the same thing as me:
> http://lkml.org/lkml/2009/4/6/93

Vegard's patch posted here fixed my issue too:

http://lkml.org/lkml/2009/4/7/142

thanks,
riccardo
