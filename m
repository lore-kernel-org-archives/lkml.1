Return-Path: <linux-kernel-owner+w=401wt.eu-S932240AbXCDCMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240AbXCDCMO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 21:12:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932636AbXCDCMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 21:12:13 -0500
Received: from wr-out-0506.google.com ([64.233.184.238]:64288 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932240AbXCDCML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 21:12:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=qE2izciibmUFMfNRSaBajOpIuYve4/tLqZKiZnD0HMjEJobmGF36UkTRJrsIIMtAAzXfIe6v2hfqyJR8/6ZClaS5+09uDhB+trseYZX7/0s5A6sTjp4ZapzxK3Mkq5iURURi4c2xO67rt/uC4ed6nUQrjMIHdb2/U1vY/XCt5MM=
Message-ID: <75b66ecd0703031812u2e3c7058pcfa0b1d54cfc8b70@mail.gmail.com>
Date: Sat, 3 Mar 2007 21:12:10 -0500
From: "Lee Revell" <rlrevell@joe-job.com>
To: Mockern@yandex.ru
Subject: Re: Question: work_queue or kthreads
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <45E9B0F9.000001.20831@colgate.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45E9B0F9.000001.20831@colgate.yandex.ru>
X-Google-Sender-Auth: 922af118d0763cd7
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/3/07, Mockern <Mockern@yandex.ru> wrote:
> hi,
>
> I need to use something like the work_queue to separate my ISR and long time sending data function in my driver. I noticed, that after using work_queue my driver became slow than it was before. Should I use kthreads to make it faster or something else? I can't use tasklet since tasklet can't sleep.
>

Please post a link to your driver source code.

Lee
