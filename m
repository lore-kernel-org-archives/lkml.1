Return-Path: <linux-kernel-owner+w=401wt.eu-S1752966AbZAJDod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbZAJDod (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 22:44:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751635AbZAJDoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 22:44:23 -0500
Received: from wf-out-1314.google.com ([209.85.200.170]:18093 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbZAJDoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 22:44:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ge6RId1A6B+1AZc5XaA6ql5d5zVLPootMjLHopVF2YWsztdLbEor2+D1GAf2+AymNu
         gC/dEtEl7MiOX/R5vdoF5k0KBumUeJNccB7Sj1sPDx6wxghEhbDW04vVtACX4DiEs4KN
         r7vm8BNwmNJfFj621eGt7w2yeR0A5NCPc6gGs=
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.1.10.0901100859000.27446@tundra.namei.org>
References: <45a44e480901091228s59259c81tee1f7d4d4b19f49a@mail.gmail.com>
	 <alpine.LRH.1.10.0901100859000.27446@tundra.namei.org>
Date: Sat, 10 Jan 2009 11:44:21 +0800
Message-ID: <45a44e480901091944q7b2fd71eu40745ed49a695620@mail.gmail.com>
Subject: Re: Oops in bluetooth on gumstix
From: Jaya Kumar <jayakumar.lkml@gmail.com>
To: James Morris <jmorris@namei.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2009 at 5:59 AM, James Morris <jmorris@namei.org> wrote:
> On Sat, 10 Jan 2009, Jaya Kumar wrote:
>
>> Hi folks,
>>
>> I pulled mainline to play with on my gumstix and encountered the
>> following oops associated with bluetooth which was previously okay on
>> 2.6.27. Here's the oops message:
>
> This patch should fix it:
>
> http://marc.info/?l=linux-kernel&m=123141356005033&w=2
>
> and should be in Linus' tree very soon.
>

Thanks James. That patch fixes the issue and things work fine now.
