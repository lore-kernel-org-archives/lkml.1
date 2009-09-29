Return-Path: <linux-kernel-owner+w=401wt.eu-S1752758AbZI2VEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758AbZI2VEi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 17:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbZI2VEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 17:04:38 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:56660 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbZI2VEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 17:04:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=AapcmAQvkWTUSV0O9dBQr2rTBu6MkY8xrq/Bxh/uZgBiGik51cvAHelhNEDAQR8MpN
         kaOrawzTAVkoeZmZfaePo2+5+nMM9rJcTgqSWf82ohDCTyWF3+9wY+oDzNuwyADznYpA
         RZy7L+lfgqu2syV9S6K5mJQptrrjnWGF5X7S4=
MIME-Version: 1.0
In-Reply-To: <1253682664-27040-1-git-send-email-vapier@gentoo.org>
References: <1253212036-29445-1-git-send-email-vapier@gentoo.org> 
	<1253682664-27040-1-git-send-email-vapier@gentoo.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 29 Sep 2009 17:04:21 -0400
Message-ID: <8bd0f97a0909291404v6d7f8a9dyb19fa8ad48f9484f@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH v2] mfd: ADP5520 Multifunction LCD 
	Backlight and Keypad Input Device Driver
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 01:11, Mike Frysinger wrote:
> From: Michael Hennerich <michael.hennerich@analog.com>
>
> Base driver for Analog Devices ADP5520/ADP5501 MFD PMICs

could you check this out/pick up Andrew ?
-mike
