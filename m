Return-Path: <linux-kernel-owner+w=401wt.eu-S1763501AbXHAJh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763501AbXHAJh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 05:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760049AbXHAJhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 05:37:22 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:51613 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759423AbXHAJhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 05:37:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:subject:from:cc:content-type:mime-version:references:content-transfer-encoding:message-id:in-reply-to:user-agent;
        b=qBVYOzPoDExLqgzy8mSN7QWhMkQOq8ADpRDNFib/0B2atVP+5eTbHwCYAKnf2daFnU9doGy28Ai/clQIYXgJ7fqp4t3KpBKgQqRGAlWLrr3nvva8G/nDm16c4fPncEVT/Zv1KQ0ClWp/MsBRutBJkbq0NUjEhYeir+WHF+Bfrzk=
Date: Wed, 01 Aug 2007 11:37:06 +0200
To: "Rene Herman" <rene.herman@gmail.com>, alan@lxorguk.ukuu.org.uk
Subject: Re: Reboot hang FIXED
From: kriko <kristjan.ugrin@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <op.twci6be2atcbto@linux.site> <46AF9DC8.7080103@gmail.com> <op.twclwllkatcbto@linux.site> <46AFABE8.7050107@gmail.com> <op.twcmvlvcatcbto@linux.site> <46AFAF4E.1000605@gmail.com> <op.twcrsx1yatcbto@linux.site> <46B038B5.2030702@gmail.com> <op.twdgw4xiatcbto@linux.site> <46B04896.5020606@gmail.com>
Content-Transfer-Encoding: 7bit
Message-ID: <op.twdjn41aatcbto@linux.site>
In-Reply-To: <46B04896.5020606@gmail.com>
User-Agent: Opera Mail/9.22 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On 08/01/2007 10:37 AM, kriko wrote:
>
>>>> using only new drivers works fine.
>>>
>>> ... oh well. I suppose it's not really worth it to try and debug that.  
>>> Cheers.
>>  I just want to add that my DVD drive is not detected when using new  
>> driver. So back to old one....
>
> You shouldn't have dropped Alan from CC then... pata_amd, right?
>
> Rene.

Sorry, yes its pata_amd.

IBM drive is on Primary master (detected as /dev/sdc)
DVD-ROM is on Secondary master (not detected)

-- 
kriko
