Return-Path: <linux-kernel-owner+w=401wt.eu-S1752015AbYKAGJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbYKAGJw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 02:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751047AbYKAGJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 02:09:44 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:42739 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbYKAGJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 02:09:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=sZtPlJm5MaVuua5gao4E8ezk4mhannfvuhMHKPPDEGxgtu3KP3wG576RnQAS0Bn22w
         bJZ6fdCusvQgArT5kmVP8TurpjGpu4VaoGxL98pYvsB5BjSdWa6IYIKNcDGQSxFPB7aY
         goTodIVR9CEZbmQeh8vN6W5pCeFBhL6zw3pmI=
Message-ID: <aa79d98a0810312309o254d4b12w68e2d9015ebe77ca@mail.gmail.com>
Date: Sat, 1 Nov 2008 09:09:41 +0300
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: nmi - document lapic and ioapic parameters
Cc: "Yinghai Lu" <yinghai@kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       "Aristeu Rozanski" <aris@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <490B7AFE.2030505@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081031192358.GC20803@localhost>
	 <86802c440810311422w79d0e697k246cb5ca76bf91b5@mail.gmail.com>
	 <490B7AFE.2030505@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 1, 2008 at 12:39 AM, H. Peter Anvin <hpa@zytor.com> wrote:
...
>
> If it's in x86-64, it's not =X86-32, so something is fishy.  The
> x86_64/boot-options.txt file really should be merged into
> kernel-parameters.txt.
>
>        -hpa
>
>
Will fix it too (ie remove this x86-32 marker). Thanks!
