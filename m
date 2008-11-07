Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbYKGJiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbYKGJiT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 04:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbYKGJiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 04:38:04 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:54820 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751374AbYKGJiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 04:38:02 -0500
X-Sasl-enc: o20d5VNJeoKwmWEsxyq+eygAPw1HcqOQ7Nkm7ZJpp8Bi 1226050681
Message-ID: <49140C76.4070300@ladisch.de>
Date: Fri, 07 Nov 2008 10:37:58 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
CC: Takashi Iwai <tiwai@suse.de>, Ingo Molnar <mingo@elte.hu>,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.26.[6|7]-rt11, alsa rawmidi, seq hang
References: <1226019485.3135.31.camel@localhost.localdomain> <49140683.9040008@ladisch.de>
In-Reply-To: <49140683.9040008@ladisch.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> I vaguely remember that we had exactly the same problem (hangs when
> using sequencer on RT kernel) some time ago, and that it was somehow
> related to tasklets.

http://lkml.org/lkml/2006/3/7/256
