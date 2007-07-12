Return-Path: <linux-kernel-owner+w=401wt.eu-S1760903AbXGLSQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760903AbXGLSQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 14:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755499AbXGLSQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 14:16:07 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:23213 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404AbXGLSQE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 14:16:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nztLnUNb+hIz0LVAoYpeeCDdAVt6/NM9CUZayqAxjas9XgPv7jxxxkPcpxvvJ+oXaRL050YyQBXIXnGfRPGpIgyDJNqzSqbeKrMgOiJ4OyvP31SRPFQTTMgb2Kz56kQ3sm76ktmppkKz+cK41y1QibiIXkLTlc/3vVR3JgLlexg=
Message-ID: <2ca024a80707121116i3574e2e2k7783bdb591b571b1@mail.gmail.com>
Date: Thu, 12 Jul 2007 19:16:03 +0100
From: "Marcos David" <marcosgdavid.ml@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: /proc/pid/status -> VmLib: 4294948464 kB
In-Reply-To: <2ca024a80707121114k530cf0f0wa79d4b40cc1cb375@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <2ca024a80707121114k530cf0f0wa79d4b40cc1cb375@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I´m using RedHat Enterprise Server 4 Update 3 (kernel 2.6.9-34.ELsmp)

I was listing the contents of /proc/pid/status file and I came up with
a value of:
...
VmLib: 4294948464 kB,
...

Is this a known bug?
the process in question uses a lot of threads ~100 but there are no
memory leaks...

Any help would be appreciated.

Thanks in advance.
Marcos David
>
