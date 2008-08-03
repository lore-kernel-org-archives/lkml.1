Return-Path: <linux-kernel-owner+w=401wt.eu-S1756536AbYHCMVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536AbYHCMVe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 08:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbYHCMV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 08:21:27 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:26682 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855AbYHCMV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 08:21:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=pOwki15g42X8GQ9NCmWIP9xtRh+TF9fPiPnsond6gLi00BxTehTtqDGOSxUT7NRW7w
         eo5RM5xJUJ+G1JEe2TzISKpPq/bxV1h7TWYVkcmxbYnJyI6BI6ofT8Yi+gG2soUP9qqF
         SCGQytQmSheInjvFMvzvMxxRj7r7T9kFUSexI=
Message-ID: <4d8e3fd30808030521t351a8564yfb93211f7239613c@mail.gmail.com>
Date: Sun, 3 Aug 2008 14:21:25 +0200
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Krzysztof Halasa" <khc@pm.waw.pl>
Subject: Re: [PATCH 2/5] x86: Coding style fixes to arch/x86/kernel/bios_uv.c
Cc: "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "H. Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       tglx <tglx@linutronix.de>
In-Reply-To: <m3iquigvqc.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080802212406.047e8ae6@paolo-desktop> <48952DB3.20101@zytor.com>
	 <48958DC2.7070506@s5r6.in-berlin.de>
	 <m3iquigvqc.fsf@maximus.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 3, 2008 at 1:54 PM, Krzysztof Halasa <khc@pm.waw.pl> wrote:
[...]
> Right. The latter is much worse. That's why nobody can trust
> CodingStyle and/or checkpatch automatically. It's only sane mode
> of operation is as a help tool for authors and maintainers, to
> quickly locate _potential_ problems.

_much worse_? Wow, I thought the opposite.
Anyway, that's just a coding style patch, feel free to simply not apply it as
it's really a matter of personal taste but be sure that I'm not
blindly changing the code
accordingly to checkpatch. That might be almost true when I started
doing this kind of patches months
ago but it's definitely not true anymore.

Thanks.

regards,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
