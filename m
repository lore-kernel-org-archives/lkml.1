Return-Path: <linux-kernel-owner+w=401wt.eu-S1754155AbYI3XNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbYI3XNR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 19:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753079AbYI3XNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 19:13:04 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:41804 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbYI3XNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 19:13:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=kxim745tu1cnAnGB1q8f9nDeHO647YSMUbpfjT19yEYgxA6zr/toaEU+op3dMHrJXc
         Pc4MjNxdsxJfcYrneOSVHPY7tOcwVDR8O5ZQE7MManA/5mc3FTDdXscEsu6EzEoBs/Ue
         Nrl2h9dNhrTob6U6EjBuo1pvUB7uEEpD8nMqk=
Message-ID: <86802c440809301613p50bed874yb8a21aaa898ec44d@mail.gmail.com>
Date: Tue, 30 Sep 2008 16:13:02 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: mtrr_cleanup update command line and doc mtrr-cleanup-debug v2
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <48E2B20D.5000404@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1222812370-16188-1-git-send-email-yhlu.kernel@gmail.com>
	 <48E2B20D.5000404@zytor.com>
X-Google-Sender-Auth: 2cb1f660287a4751
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2008 at 4:11 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Yinghai Lu wrote:
>>
>> change enable_mtrr_cleanup to mtrr-cleanup, disable_mtrr_cleanup to
>> nomtrr-cleanup.
>> so doc mtrr-cleanup-debug.
>>
>> v2: some _ to -
>>
>> and change MTRR_SANITIZER to def_bool y
>
> Could you split that into two patches, please?
>
will split into three.

YH
