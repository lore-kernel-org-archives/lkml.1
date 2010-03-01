Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747Ab0CAS5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 13:57:48 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:56316 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab0CAS5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 13:57:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=CTaYutvgUwcSF3BH4cN9tKMS4PZ4bAPoAXb0T3jGat80H4JM428m2Dbw+L2ZITXwr3
         +lRMzPeKgH77H5KSTKqvF7qFj4BAa8IvtB0Gl0LEORYfOOrXC+o0jXyn/YSexJ9uowwY
         ZiqM8PNoliS8Lk38sJBmHjhE7FFZoU1heH4fg=
MIME-Version: 1.0
In-Reply-To: <4B8C068A.4040402@zytor.com>
References: <1267463700-25524-1-git-send-email-luca@luca-barbieri.com>
	 <4B8C068A.4040402@zytor.com>
Date: Mon, 1 Mar 2010 19:57:45 +0100
X-Google-Sender-Auth: d83157b639c7bc1b
Message-ID: <ff13bc9a1003011057s65fab4e5t7c37ebba5af16c9e@mail.gmail.com>
Subject: Re: [PATCH 0/3] Fix atomic64_add_unless return value convention
From: Luca Barbieri <luca@luca-barbieri.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, paulus@samba.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> The x86-32 and atomic64_test.c patches should probably be squashed in the
>> appropriate commits in tip/x86/atomic
>
> We tend to be very reluctant to do that.
OK: I suggested that to avoid introducing broken commits that could
cause annoyance in bisections.

> Anyway, please resend your patches with actual patch descriptions
> (commit messages).
Resent with more verbose descriptions.
