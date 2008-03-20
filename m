Return-Path: <linux-kernel-owner+w=401wt.eu-S1756698AbYCTT4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbYCTT4d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 15:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754459AbYCTT4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 15:56:25 -0400
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:42815 "EHLO
	QMTA02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753959AbYCTT4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 15:56:24 -0400
X-Authority-Analysis: v=1.0 c=1 a=0M346g1JBBMA:10 a=y4c5MiR-AAAA:8
 a=UaMh_QsRMryB30rWN9EA:9 a=HnpzKa48DuZYW4cqsIIA:7
 a=a6j99q-9xOA0NF1f0rd_ICx0RUcA:4 a=Mz_smNXqyOQA:10
Message-ID: <47E2C158.5010008@andrei.myip.org>
Date: Thu, 20 Mar 2008 12:56:08 -0700
From: Florin Andrei <florin@andrei.myip.org>
Reply-To: linux-kernel@vger.kernel.org
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: kernel support for newer UDF versions (> 2.01)
References: <1201981141.3197.7.camel@fermat.scientia.net> <20080206163611.GB23382@atrey.karlin.mff.cuni.cz> <1202327121.3236.17.camel@fermat.scientia.net> <20080207094538.GA6140@duck.suse.cz>
In-Reply-To: <20080207094538.GA6140@duck.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara wrote:
> On Wed 06-02-08 20:45:21, Christoph Anton Mitterer wrote:
>> On Wed, 2008-02-06 at 17:36 +0100, Jan Kara wrote:
>>> I think there's a patch for 2.50 support which is quite recent (2.6.24).
>>> I plan to merge the support when Sebastian submits it (I'm already in
>>> contact with him regarding this).
>> Ah great, so 2.6.25 probably?!
>   Not very likely for 2.6.25 (I still don't have a patch with Sebastians's
> Sign-off without which I cannot merge it and 2.6.25 merge window is closing
> soon...). But hopefully it'll make it into 2.6.26.

What's the status of the UDF 2.50 patch currently? Still on track for 
inclusion in 2.6.26?

Where can I find a patch that works with the latest stable kernel? 
(2.6.24.3)

-- 
Florin Andrei

http://florin.myip.org/
