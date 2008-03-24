Return-Path: <linux-kernel-owner+w=401wt.eu-S1755429AbYCXWa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429AbYCXWa4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 18:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753600AbYCXWar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 18:30:47 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:55213 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569AbYCXWaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 18:30:46 -0400
Message-ID: <47E82BDD.9060507@keyaccess.nl>
Date: Mon, 24 Mar 2008 23:31:57 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Junio C Hamano <gitster@pobox.com>
CC: Catalin Marinas <catalin.marinas@gmail.com>,
       Jan Engelhardt <jengelh@computergmbh.de>, git <git@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Josef Sipek <jsipek@fsl.cs.sunysb.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [ANNOUNCE] Stacked GIT 0.14.2
References: <b0943d9e0803241259s5280cdc1o255a4412b3fa7bfc@mail.gmail.com> <alpine.LNX.1.10.0803242113070.9368@fbirervta.pbzchgretzou.qr> <47E81037.5030808@keyaccess.nl> <7vlk47ua3v.fsf@gitster.siamese.dyndns.org>
In-Reply-To: <7vlk47ua3v.fsf@gitster.siamese.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24-03-08 21:43, Junio C Hamano wrote:

> Rene Herman <rene.herman@keyaccess.nl> writes:
> 
>> On 24-03-08 21:15, Jan Engelhardt wrote:
>>
>>> On Monday 2008-03-24 20:59, Catalin Marinas wrote:
>>>
>>>> Stacked GIT 0.14.2 release is available from
>>>> http://www.procode.org/stgit/.
>>>>
>>>> StGIT is a Python application providing similar functionality to Quilt
>>>> (i.e. pushing/popping patches to/from a stack) on top of GIT.
>>> I always wondered what the difference between stgit and guilt is.
>>> Does anyone have a comparison up?
>> And I remember some mumblings about git growing quilt-like
>> functionality itself. Anything on that?
> 
> Not my mumbling

Believe it was Linus. Seem to remember him saying something about possibly 
adding a native queues-like interface not too long ago but it's proving 
impossible to google for.

> but I am quite open to slurp in guilt as a subdirectory in git.git at
> some point in the future just like we bundle git-gui and gitk if asked by
> the maintainer.
> 
> The same applies to StGIT for that matter, although I somehow feel that
> is much less likely to happen, because it lived long enough as a
> standalone project with enough following to achieve sustainable momentum
> by itself.

Rene.
