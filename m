Return-Path: <linux-kernel-owner+w=401wt.eu-S1756535AbZHZFIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535AbZHZFIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 01:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755954AbZHZFIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 01:08:53 -0400
Received: from mail-gx0-f205.google.com ([209.85.217.205]:50241 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594AbZHZFIw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 01:08:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dm0/46E6N2eToF7SHGdQs9E/Q6e6jDA7lmzFi3YcpDLQkQr4ALeBjL5kwB006EaKTu
         WQ5yOIHXbhHNICnyUlx06OGxXQl3mO+IjqWO952GiaS99QH/e9+jVERiGWe6ewR0U3b7
         bFHFChb7YJqQarww5jFDnvx1kvxM8cd322TcI=
MIME-Version: 1.0
In-Reply-To: <30c949580908251825n59da4bceg77c464eca01f0c46@mail.gmail.com>
References: <30c949580908251825n59da4bceg77c464eca01f0c46@mail.gmail.com>
Date: Wed, 26 Aug 2009 14:08:54 +0900
Message-ID: <18eba5a10908252208p791288e3mc28f6aaf8306948f@mail.gmail.com>
Subject: Re: oom-killer works,but the memory cannot be freed
From: Chungki woo <chungki.woo@gmail.com>
To: Bill Xie <bill790@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi~ bill
There is no enough information about your problem.
Can you show me some logs like oom message and /proc/meminfo after oom?

2009/8/26 Bill Xie <bill790@gmail.com>:
> My harware is a mips-achitecture hand-hold device, runs 2.6.24.3 and qt.
> when an application program  opened a 3.2M pdf file, the memory was
> consuming continually, finally the "oom-killer" things happened, the
> applicaton was killed,
>  but the memory occupied by the application still can not be freed. Is
> there some methods

I want to know why you think like this.

> to do with this situation?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Thanks.
