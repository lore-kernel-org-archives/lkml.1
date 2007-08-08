Return-Path: <linux-kernel-owner+w=401wt.eu-S1763384AbXHHJh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763384AbXHHJh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 05:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758041AbXHHJhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 05:37:48 -0400
Received: from hu-out-0506.google.com ([72.14.214.226]:1503 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757874AbXHHJhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 05:37:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=HeDc3LTRyyWN6o667x5KIZgDb3PEYyztrOQuv9JyAQsWk3sMR3dBqHtJakxLCX0fDtH4PBCCHvMsh9E9j3pJG9L0fdroEHOwIv3Nr/AEnkCUeM+SH2H/vcSWKqZeR5TKE3EuQ4xAEbz2MlR564mq1eJfMHdRCpF/3sfIv8meDvo=
Message-ID: <46B98ED6.4020902@gmail.com>
Date: Wed, 08 Aug 2007 11:37:26 +0200
From: dragoran <drago01@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: allow non root users to set io priority "idle" ?
References: <46B6EDCB.6030806@gmail.com> <p73zm14lxyy.fsf@bingen.suse.de> <46B6F75D.1070808@gmail.com> <20070806103553.GA16133@one.firstfloor.org> <20070807204449.GA5245@kernel.dk> <f6ca9fed0708071435h31531279gb6ea0fc760be98df@mail.gmail.com> <f6ca9fed0708071518m159e0ef8vc2d8482913afbea6@mail.gmail.com> <20070808050617.GE5245@kernel.dk>
In-Reply-To: <20070808050617.GE5245@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Wed, Aug 08 2007, dragoran wrote:
>   
>> so there is no real reason not to allow it for non root users?
>> removing the check is easy (3 lines) ....
>> or are there any other issues/problems?
>>     
>
> Andi already explained to you why it can't be enabled for non-root
> users. I merely talked about why idle priority works.
>
>   
ok, I missunderstood you.
shouldn't read mails at 0:18 am ;)

