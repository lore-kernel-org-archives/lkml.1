Return-Path: <linux-kernel-owner+w=401wt.eu-S1759230AbYFTQLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759230AbYFTQLZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 12:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbYFTQLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 12:11:17 -0400
Received: from gw.goop.org ([64.81.55.164]:45314 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326AbYFTQLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 12:11:17 -0400
Message-ID: <485BD6A4.2010508@goop.org>
Date: Fri, 20 Jun 2008 09:11:16 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] x86: unify asm-x86/fixmap*.h
References: <4858056D.7000500@goop.org> <20080620131041.GA19740@elte.hu>
In-Reply-To: <20080620131041.GA19740@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Almost everything aside from the actual fixmap slot definitions is 
>> common, so move it all into the common fixmap.h header.
>>     
>
> nice patches! I have created a new -tip topic for them: tip/x86/fixmap, 
> and have added them there. (This topic will also be in auto-x86-next on 
> the next integration run.)

Your scripts seem to have lost the first paragraph of the commit comment 
for these changes.

    J
