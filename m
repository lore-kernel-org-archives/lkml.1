Return-Path: <linux-kernel-owner+w=401wt.eu-S1757456AbYFPRz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456AbYFPRz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 13:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbYFPRzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 13:55:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52880 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbYFPRzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 13:55:13 -0400
Message-ID: <4856A8E0.4060408@zytor.com>
Date: Mon, 16 Jun 2008 10:54:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: trenn@suse.de
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "andreas.herrmann3" <andreas.herrmann3@amd.com>,
       Richard <tuxbox.guru@gmail.com>, eumaster@gmail.com,
       uli.geins@geins-web.de
Subject: Re: AMD Mobile Semprons (3500+, 3600+,...) break with nohz and highres
 enabled
References: <1213638474.1684.21.camel@queen.suse.de>
In-Reply-To: <1213638474.1684.21.camel@queen.suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Renninger wrote:
>   - This affects AMD Mobile Semprons (at least 3500+ and 3600+)
> 
> This seem to be a mainline kernel regression since the nohz/highres
> patches have been added.
> I do not own such a machine myself (Richard, Evgeny, Uli (and Anvin?)
> have such a machine and already helped to come that far).

'Fraid I don't.  :(

	-hpa
