Return-Path: <linux-kernel-owner+w=401wt.eu-S1757622AbYCMVym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622AbYCMVym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 17:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752849AbYCMVyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 17:54:31 -0400
Received: from ns2.g-housing.de ([81.169.133.75]:46401 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757324AbYCMVya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 17:54:30 -0400
Date: Thu, 13 Mar 2008 22:54:25 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: Chr <chunkeey@web.de>
cc: Samuel Tardieu <sam@rfc1149.net>,
       device-mapper development <dm-devel@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: INFO: task mount:11202 blocked for more than 120 seconds
In-Reply-To: <200803132233.47516.chunkeey@web.de>
Message-ID: <alpine.DEB.1.00.0803132249060.7433@sheep.housecafe.de>
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de> <alpine.DEB.1.00.0803130003110.5593@sheep.housecafe.de> <alpine.DEB.1.00.0803131444480.7433@sheep.housecafe.de> <200803132233.47516.chunkeey@web.de>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008, Chr wrote:
> On Thursday 13 March 2008 14:45:39 Christian Kujau wrote:
>> and so does -git8 and -git9...sigh :(
>
> hmm, I can boot any of these -rcX-gitY kernels (but not without some stuck
> tasks after about a hour or so...)

Ah, when you said -git17 would be the last "good" kernel, I thought 
everything earlier would not have the stuck tasks.

> but back: I tried lockdep and ran into this: (debug blocker)

I have lockdep enabled as well, but no warnings so far...

> sounds a bit strange? Is this a SMP related problem after all?

I don't think so, as I don't have an SMP system (and CONFIG_SMP is 
disabled as well).

C.
-- 
BOFH excuse #441:

Hash table has woodworm
