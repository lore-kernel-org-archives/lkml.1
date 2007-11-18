Return-Path: <linux-kernel-owner+w=401wt.eu-S1754005AbXKRNs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbXKRNs7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 08:48:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbXKRNsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 08:48:51 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:11639 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbXKRNsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 08:48:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VjhnmiUHwL/Z/U6yuK+q3Qwvc6y7nub1vMqzTxmOl4i6C/FqXxnYC7QaPb72szs06TEK8P1iQ2lJsXCvdvbKlIZn8aehbJ2KKH92VFir2Fcnldl7LD+jdcBSSihzFciVU2pl4rwBv+HNz3jVuA4/umW9YLwM89Fj9hUkh67jeko=
Message-ID: <5699f8f00711180548i13ffd232oe08cdafa87be6e2@mail.gmail.com>
Date: Sun, 18 Nov 2007 14:48:50 +0100
From: "Wander Winkelhorst" <w.winkelhorst@gmail.com>
To: "kernel coder" <lhrkernelcoder@gmail.com>
Subject: Re: increased number of cycles
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <f69849430711172131j41c21d84y2ac10759eff29eb7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f69849430711172131j41c21d84y2ac10759eff29eb7@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> But for last 4 days the consumed cycles have suddenly increased to
> around 35 cycles . I'm using RDTSC instruction to profile the
> code.There is no change in code and the kernel version is also the
> same .I am assuming that there  must be something wrong with hardware.
>
> Please guide me how can i figure out the root cause.What areas should

Maybe you have a new version of GCC now? (auto-update or something?)
