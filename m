Return-Path: <linux-kernel-owner+w=401wt.eu-S1757858AbZFVTTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858AbZFVTTr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 15:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbZFVTTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 15:19:40 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:58340 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbZFVTTj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 15:19:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pFku39Mk6EyC3lmQPYLow/Cvu0vaF3PL1uQxrkClnGo1FhCYDyHC9aVKy6eSmAFZjA
         9Ihhlsh4H0C4bF5rN7TQYORlprTdWFNrxAtKrKTo667aK9lKGrTuIF6Rcw2a8ZBi/34C
         LGyP1QlGyryLSZjZdXzz65Ucen0Xc34AyFiS4=
MIME-Version: 1.0
In-Reply-To: <8db1092f0906221145w3c5113edp1eec1368dcc11f33@mail.gmail.com>
References: <8db1092f0906211002y2b391212ve2902fc3a6517586@mail.gmail.com>
	 <8db1092f0906221037m30c7966bx6870b4eeb9ee16ea@mail.gmail.com>
	 <8db1092f0906221112y241abc19nb2b0a4a75ef253b4@mail.gmail.com>
	 <200906222041.06103.rjw@sisk.pl>
	 <8db1092f0906221145w3c5113edp1eec1368dcc11f33@mail.gmail.com>
Date: Mon, 22 Jun 2009 21:19:41 +0200
Message-ID: <8db1092f0906221219l5a599b1bj8bbe9a05c5f0b156@mail.gmail.com>
Subject: Re: 2.6.30-git(16 and 17) system hangs after resume from suspend to 
	disk, mce related?
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andi Kleen <ak@linux.intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/22 Maciej Rutecki <maciej.rutecki@gmail.com>:

>> Before 2. in your procedure run 'echo core > /sys/power/pm_test'.  It will not
>
> I will check.

1. boot, don't change check_interval
2. echo core > /sys/power/pm_test
3. suspend to disk
4. wait 15 minutes, system doesn't hangs.


-- 
Maciej Rutecki
http://www.maciek.unixy.pl
