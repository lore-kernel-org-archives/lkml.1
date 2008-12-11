Return-Path: <linux-kernel-owner+w=401wt.eu-S1755196AbYLKJ1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbYLKJ1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 04:27:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754350AbYLKJ05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 04:26:57 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:57029 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754332AbYLKJ04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 04:26:56 -0500
Date: Thu, 11 Dec 2008 10:26:50 +0100
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Alex Raimondi <mailinglist@miromico.ch>
Cc: kernel@avr32linux.org, linux-kernel@vger.kernel.org
Subject: Re: Segfault in fbcmap.c => Compiler bug?
Message-ID: <20081211102650.4d17f236@hcegtvedt>
In-Reply-To: <4940D8C0.9060709@miromico.ch>
References: <4940CE1F.5080605@miromico.ch>
	<20081211092959.6410c352@hcegtvedt>
	<4940D8C0.9060709@miromico.ch>
Organization: Atmel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Dec 2008 10:09:20 +0100
Alex Raimondi <mailinglist@miromico.ch> wrote:

<snipp>

> > Which toolchain are you using? If you have grabbed it from atmel.com
> > you have to download Buildroot for AVR32 [1] and build your own
> > toolchain. The toolchain on atmel.com is broken.
> 
> I have both. AV32 toolchain from atmel is installed via apt-get. I
> have builroot 2.2.1 which generated a toolchain, as well. 
> 
> but kernel compilation is done using apt-get toolchain.
> 
> So, your suggestion is to remove the atmel stuff completely and use
> only buildroot toolchain?
> 

Yes, indeed. The toolchain you got via the apt repository is broken.

-- 
Best regards,
Hans-Christian Egtvedt
