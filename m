Return-Path: <linux-kernel-owner+w=401wt.eu-S1756531AbYCXXWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531AbYCXXWX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 19:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751237AbYCXXWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 19:22:08 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:58581 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756030AbYCXXWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 19:22:07 -0400
Message-ID: <47E837E8.7000606@keyaccess.nl>
Date: Tue, 25 Mar 2008 00:23:20 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@gmail.com>
CC: Junio C Hamano <gitster@pobox.com>,
       Jan Engelhardt <jengelh@computergmbh.de>, git <git@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Josef Sipek <jsipek@fsl.cs.sunysb.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [ANNOUNCE] Stacked GIT 0.14.2
References: <b0943d9e0803241259s5280cdc1o255a4412b3fa7bfc@mail.gmail.com>	 <alpine.LNX.1.10.0803242113070.9368@fbirervta.pbzchgretzou.qr>	 <47E81037.5030808@keyaccess.nl>	 <7vlk47ua3v.fsf@gitster.siamese.dyndns.org>	 <47E82BDD.9060507@keyaccess.nl> <b0943d9e0803241550k3ef0dbe8nae3b00bac34fa20@mail.gmail.com>
In-Reply-To: <b0943d9e0803241550k3ef0dbe8nae3b00bac34fa20@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24-03-08 23:50, Catalin Marinas wrote:

> On 24/03/2008, Rene Herman <rene.herman@keyaccess.nl> wrote:
>> On 24-03-08 21:43, Junio C Hamano wrote:

>>  >> On 24-03-08 21:15, Jan Engelhardt wrote:

>>  >>> I always wondered what the difference between stgit and guilt is.
>>  >>> Does anyone have a comparison up?
>>  >> And I remember some mumblings about git growing quilt-like
>>  >> functionality itself. Anything on that?
>>  >
>>  > Not my mumbling
>>
>>
>> Believe it was Linus. Seem to remember him saying something about possibly
>> adding a native queues-like interface not too long ago but it's proving
>> impossible to google for.
> 
> It was Linus indeed, on the linux-arch mailing list:
> 
> http://www.mail-archive.com/linux-arch@vger.kernel.org/msg05012.html

Probably read it on linux-kernel but yes, that was the one, thanks much. 
Stored it as an interesting something -- used to use quilt and although I 
didn't much care for its linear nature when managing an entire tree, it 
probably works out well for private topic branches. Not overly sure of added 
practical value over git rebase, but I did like the simple nature of 
shuffling things around by just editing a series file back when I was using 
quilt. Keeps one on top of things, so to speak (<-- amusing play on words).

Moreover not too keen on using many tools do do one thing, so getting this 
inside git itself sounded like a possibly nice notion.

Rene.
