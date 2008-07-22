Return-Path: <linux-kernel-owner+w=401wt.eu-S1753778AbYGVOAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbYGVOAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 10:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751329AbYGVN7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 09:59:54 -0400
Received: from styx.suse.cz ([82.119.242.94]:35961 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750975AbYGVN7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 09:59:53 -0400
Date: Tue, 22 Jul 2008 15:59:52 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, robfitz@273k.net, akpm@osdl.org,
       Vojtech Pavlik <vojtech@suse.cz>, dmonakhov@openvz.org
Subject: Re: [PATCH] hid: wellspring device quirks
In-Reply-To: <20080722095311.ZZRA012@mailhub.coreip.homeip.net>
Message-ID: <alpine.LNX.1.10.0807221559010.3037@jikos.suse.cz>
References: <1215963466.12757.0.camel@alnilam> <alpine.LNX.1.10.0807221504380.3037@jikos.suse.cz> <4885E13E.1010607@euromail.se> <20080722095311.ZZRA012@mailhub.coreip.homeip.net>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2008, Dmitry Torokhov wrote:

> Should I take the quirks patch through my tree when I'm ready to apply 
> bcm5974?

Hi Dmitry,

that would be the best option, thanks a lot. Please feel free to add

 	Signed-off-by: Jiri Kosina <jkosina@suse.cz>

to Henrik's quirk addition patch when you are going to merge it.

Thanks,

-- 
Jiri Kosina
SUSE Labs
