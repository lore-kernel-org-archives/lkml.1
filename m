Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246Ab0BYEHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 23:07:50 -0500
Received: from mail-yw0-f197.google.com ([209.85.211.197]:38975 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932091Ab0BYEHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 23:07:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=QU5v2DX4mB8DDMJSnOZW4QdILUayf3ljcgea7BktLgTmsi3vOWIRG+m89wupIGqPgs
         3c3jnL50bXe0AMAS4eFYZ6Jq4h/IsMB7WUHbC4VOEF8tFpBShQHwHI8V9Hn5fAwtfFQ1
         Mbq8CnF55NYWolV6Z/5JihuvDBLUegCua3nfc=
Message-ID: <4B85F786.806@garzik.org>
Date: Wed, 24 Feb 2010 23:07:34 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: Re: [git patch] libata bug fix
References: <20100225034937.GA26364@havoc.gtf.org> <20100224200335.32d43577.akpm@linux-foundation.org>
In-Reply-To: <20100224200335.32d43577.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2010 11:03 PM, Andrew Morton wrote:
> On Wed, 24 Feb 2010 22:49:37 -0500 Jeff Garzik<jeff@garzik.org>  wrote:
>
>>
>> This is a fix that probably should have gone into 2.6.33.
>
> It still can if we cc stable@kernel.org?

The commit message includes the Cc as per standard.

	Jeff



