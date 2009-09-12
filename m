Return-Path: <linux-kernel-owner+w=401wt.eu-S1752984AbZILJe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984AbZILJe1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 05:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbZILJe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 05:34:26 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:45634 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbZILJe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 05:34:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=YBwmSWNBmpCH72gNK/kx7hsxk+ulaXCVGBT6rBfkqSeIbkZmaTaq28FFM3jIq6L7lz
         zpnwc7e4e4xRCWz5a/oSbpXtdIr1qIvFFEc8p7ImHYqE98+/gvoiISsqS6w5HJCvXh8u
         73OP6Pbp2zZXb1AKvP2Qo5GTmEd/9URRQS1yQ=
From: Volker Armin Hemmann <volkerarmin@googlemail.com>
To: Nikos Chantziaras <realnc@arcor.de>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Date: Sat, 12 Sep 2009 11:34:25 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31r4; KDE/4.3.1; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Con Kolivas <kernel@kolivas.org>, LKML <linux-kernel@vger.kernel.org>
References: <200909112033.34445.volkerarmin@googlemail.com> <200909121027.08244.volkerarmin@googlemail.com> <4AAB63F8.1060301@arcor.de>
In-Reply-To: <4AAB63F8.1060301@arcor.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200909121134.25243.volkerarmin@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Samstag 12 September 2009, Nikos Chantziaras wrote:

> Seeing the "lost 1 rtc interrupts" message makes me wonder if this could
> possibly relate to problems with the C1E state on AMD systems (missing
> timer interrupts):
> 
>    http://lkml.org/lkml/2008/6/12/127
> 
> That thread is one year old though and your Phenom II CPU was released 7
> months later.
> 

thanks for the link!
