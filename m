Return-Path: <linux-kernel-owner+w=401wt.eu-S1756733AbYLaQcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733AbYLaQcI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 11:32:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756035AbYLaQby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 11:31:54 -0500
Received: from rtr.ca ([76.10.145.34]:56562 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755782AbYLaQbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 11:31:53 -0500
Message-ID: <495B9ED3.8050008@rtr.ca>
Date: Wed, 31 Dec 2008 11:33:23 -0500
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.27.10: ata1.00: HPA detected: current 293044655, native 
  293046768
References: <alpine.DEB.1.10.0812300657050.11356@p34.internal.lan> <495A5A9F.9020406@shaw.ca>
In-Reply-To: <495A5A9F.9020406@shaw.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Justin Piszcz wrote:
>> On one system, two Raptor 150s:
>>
>> [    0.739402] ata1.00: HPA detected: current 293044655, native 293046768
..
> Presumably somebody or something set up a host protected area on one 
> drive and not the other.. I believe there are some utilities out there 
> that can be used to disable the HPA and allow the full capacity to be used.
..

"hdparm -N" can do this, temporarily or permanently.
Get the latest version from Sourceforge, and see the manpage for details.

-ml

