Return-Path: <linux-kernel-owner+w=401wt.eu-S1754642AbZEMFIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbZEMFIo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 01:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998AbZEMFIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 01:08:35 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:44345 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbZEMFIe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 01:08:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UA+f4LOq9vAROEvPCX2axhZyhEgn4kNDvVexszuqwoD9ld/IhnVBTScBNQA3XDhtIT
         zo0J48ZnQCe8db/X/sMDElVfbBj+L8akanx9oQfZHL6jq33+1flUl9qk657Chyo8v1y9
         wPi0/WuQlZ1vsK/gaQWWl1EzZ1pa4ix995iCk=
MIME-Version: 1.0
In-Reply-To: <20090512185415.GA22500@Krystal>
References: <1233911220-27912-1-git-send-email-bert.wesarg@googlemail.com>
	 <20090512185415.GA22500@Krystal>
Date: Wed, 13 May 2009 07:08:34 +0200
Message-ID: <36ca99e90905122208s69b8f594wa9c8ca78781f778e@mail.gmail.com>
Subject: Re: [PATCH urcu] Use pthread_equal() for pthread_t's equality test
From: Bert Wesarg <bert.wesarg@googlemail.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 20:54, Mathieu Desnoyers
<compudj@krystal.dyndns.org> wrote:
> * Bert Wesarg (bert.wesarg@googlemail.com) wrote:
>> Signed-off-by: Bert Wesarg <bert.wesarg@googlemail.com>
>> ---
>>  urcu.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>
> Hi Bert,
Hi Mathieu,
>
> I have to ask all userspace RCU committers for permission to move the
> code to LGPL. IBM already gave their approval. Is it OK with you wrt to
> the patch you posted here ?
Yes, it's ok.

Bert
>
> Mathieu
