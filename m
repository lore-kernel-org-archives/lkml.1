Return-Path: <linux-kernel-owner+w=401wt.eu-S1758870AbZKKU6E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758870AbZKKU6E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 15:58:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757931AbZKKU6C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 15:58:02 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:57929 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756940AbZKKU6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 15:58:01 -0500
Message-ID: <4AFB2547.7080008@ti.com>
Date: Wed, 11 Nov 2009 14:57:43 -0600
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/2] Dynamic Tick: Enabling longer sleep times on 32-bit
 	machines
References: <1250617512-23567-1-git-send-email-jon-hunter@ti.com> <1f1b08da0911111243s2615c22ake73a3242becb7b70@mail.gmail.com>
In-Reply-To: <1f1b08da0911111243s2615c22ake73a3242becb7b70@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


john stultz wrote:
> I could have sworn this was in mainline by now, but I recently was
> looking for the code and can't find it there or in -tip either.
> 
> Thomas, are they just hiding somewhere I can't find?
> 
> Jon, you've been terribly patient and great about resubmitting these
> patches over and over. If I'm not just being crazy and missing these
> patches in front of my nose, are you still willing to submit them
> again? I think they'll be quite useful as folks start pushing the NOHZ
> idle times out.

Absolutely! It is still on my to-do list, but unfortunately, I got busy 
with a couple other things.

With regard to the last patch set I submitted for this, Thomas had an 
issue with one of the patches. I understand the concern, but I am not 
sure  which would be the preferred way to handle this. See the below thread:

http://marc.info/?l=linux-kernel&m=125062817124381&w=2

If you or Thomas have any feedback on this, I could re-work the patch 
against the latest kernel tree.

Cheers
Jon
