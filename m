Return-Path: <linux-kernel-owner+w=401wt.eu-S1752620AbZGROu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbZGROu1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 10:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbZGROu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 10:50:26 -0400
Received: from rtr.ca ([76.10.145.34]:45061 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183AbZGROu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 10:50:26 -0400
Message-ID: <4A61E12F.6040502@rtr.ca>
Date: Sat, 18 Jul 2009 10:50:23 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: =?UTF-8?B?QnJ1bm8gUHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] HID: Input driver for Twinhan USB 6253:0100 remote control
References: <20090408072935.GA27920@dtor-d630.eng.vmware.com>	<200904131931.24009.dmitry.torokhov@gmail.com>	<49E4B678.9030508@rtr.ca>	<200904140945.14652.dmitry.torokhov@gmail.com>	<49E4C9CF.5060504@rtr.ca>	<alpine.LNX.2.00.0904151022170.13028@wotan.suse.de>	<49E5EAD7.7000309@rtr.ca>	<alpine.LNX.2.00.0904161123180.13028@wotan.suse.de>	<20090712182026.7a09c736@neptune.home>	<alpine.LNX.2.00.0907131048110.10476@wotan.suse.de>	<20090713113157.701ba027@neptune.home>	<alpine.LNX.2.00.0907131316420.10476@wotan.suse.de> <20090713141958.4d17f32a@neptune.home>
In-Reply-To: <20090713141958.4d17f32a@neptune.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good work, Bruno (and Jiri and Dmitry)!

I know of three people locally that are using my original driver,
and when they next upgrade kernels, they now have Bruno's version
to replace that with.

Thanks!
