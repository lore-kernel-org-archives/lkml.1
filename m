Return-Path: <linux-kernel-owner+w=401wt.eu-S933128AbXJPQxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933128AbXJPQxQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 12:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933467AbXJPQwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 12:52:55 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:50747 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932802AbXJPQwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 12:52:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=OJSO5SYqWmPXxSjrO0TXEsVq9hqR8vs5oTuDYsXPx5E/qtUnJvGh/nMUw+IdaVWEkXWuSMJIdMczHxheXr/+S+HuvZbn2qyEAekVfE8v6cDYeK+Tu04NwXkv00ohYtJ7USLVow+evNSrjJQpIT3hsL6k15tdn6CM9yMjrZc7Cqw=
Message-ID: <4714EC6A.20604@gmail.com>
Date: Tue, 16 Oct 2007 20:52:58 +0400
From: Konstantin Kalin <konstantin.kalin@gmail.com>
User-Agent: Thunderbird 1.5.0.13 (Windows/20070809)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: NVIDIA Ethernet & invalid MAC
References: <4714C66D.4010607@gmail.com>	<20071016154313.53d19c43@the-village.bc.nu>	<4714D5B8.8020301@redhat.com> <20071016164354.6f4e530a@the-village.bc.nu> <4714E02D.7040804@garzik.org> <4714E842.8020105@gmail.com> <4714E9D5.7040303@garzik.org>
In-Reply-To: <4714E9D5.7040303@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Well, I'm understanding it...and there needs three bytes. But looks like 
there is no other way to fix it taking into account other complaints.
Anyhow I couldn't find difference in this motherboard today  :(

Thank you,
Kostya.
 
Jeff Garzik wrote:
> Konstantin Kalin wrote:
>> I'm sorry, but I think that Alan proposed in the first email is more 
>> than a hack. It would solve the issue for different versions and the 
>> check is trivial. Or am I mistaken?
>
> It assumes a constant MAC address vendor ID.
>
>     Jeff
>
>
>

