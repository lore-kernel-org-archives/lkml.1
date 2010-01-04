Return-Path: <linux-kernel-owner+w=401wt.eu-S1752358Ab0ADAjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358Ab0ADAjP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 19:39:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751701Ab0ADAjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 19:39:13 -0500
Received: from 62.1.125.199.dsl.dyn.forthnet.gr ([62.1.125.199]:21187 "EHLO
	poseidon.vergina.dyndns.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751594Ab0ADAjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 19:39:13 -0500
Message-ID: <4B4138AB.3060602@asyr.hopto.org>
Date: Mon, 04 Jan 2010 02:39:07 +0200
From: Thanasis <thanasis@asyr.hopto.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091229 Thunderbird/3.0 ThunderBrowse/3.2.6.8
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: gentoo-user@lists.gentoo.org, Dirk Heinrichs <dirk.heinrichs@online.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [gentoo-user] RAM installed vs reported
References: <4B3B3043.20400@asyr.hopto.org>	<200912301208.54359.dirk.heinrichs@online.de>	<4B3B38F2.6090006@asyr.hopto.org>	<m3fx6r8a0l.fsf@intrepid.localdomain>	<4B3CF04E.8070603@asyr.hopto.org>	<m3vdfmosha.fsf@intrepid.localdomain>	<4B406CDF.7010301@asyr.hopto.org> <m3aawulr8t.fsf@intrepid.localdomain>
In-Reply-To: <m3aawulr8t.fsf@intrepid.localdomain>
Content-Type: text/plain; charset=ISO-8859-7
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 01/04/2010 01:10 AM Krzysztof Halasa wrote the following:
> Thanasis <thanasis@asyr.hopto.org> writes:
>
>   
>> Hmm..., but are EMBEDDED options suitable for a netbook like the A110L ?
>>     
> This "EMBEDDED" just means "don't touch these unless you really know
> what you're doing".
>
> BTW I remember using VMSPLIT 2 GB : 2 GB on server-class machines,
> before they were upgraded to x86-64.
>   
Do you mean that I should try it? Is there any gain over using
CONFIG_HIGHMEM4G ?
