Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbYFYUUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbYFYUUO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 16:20:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbYFYUUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 16:20:01 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:42585 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbYFYUUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 16:20:00 -0400
Message-ID: <4862A8A2.8050407@keyaccess.nl>
Date: Wed, 25 Jun 2008 22:20:50 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Bernd Schubert <bernd-schubert@gmx.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: x86: enable pat on amd athlon mode=6
References: <200806252153.35675.bernd-schubert@gmx.de> <4862A757.3020002@keyaccess.nl>
In-Reply-To: <4862A757.3020002@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25-06-08 22:15, Rene Herman wrote:

> On 25-06-08 21:53, Bernd Schubert wrote:
> 
>> on my AthlonXP 1700 PAT works fine (I tested it several days). Please
>> accept one of the patches below, I don't know which you refer.
>>
>> Signed-off-by: Bernd Schubert <bernd-schubert@gmx.de>
> 
> Yes, PAT works equally well on my earlier model 6. The setup's already 
> changed in linux-next though and now blacklists some Intel models only:
> 
> http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=blob;f=arch/x86/kernel/cpu/addon_cpuid_features.c;h=84a8220a6072c0425b9da95fbb28b5a309cbfda1;hb=HEAD 

Well, if I provide a link, I might as well look at it myself I guess...

Earlier patches on linux-kernel did the white->black list switching but 
as you can see that in linux-next at least all of AMD is already 
whitelisted.

Rene.
