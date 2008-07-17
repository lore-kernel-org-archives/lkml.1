Return-Path: <linux-kernel-owner+w=401wt.eu-S932103AbYGQTTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103AbYGQTTc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 15:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759239AbYGQTTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 15:19:04 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:48016 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758072AbYGQTTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 15:19:01 -0400
Message-ID: <487F9B9B.2010905@keyaccess.nl>
Date: Thu, 17 Jul 2008 21:20:59 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Ingo Molnar <mingo@elte.hu>, Jaroslav Kysela <perex@perex.cz>,
       LKML <linux-kernel@vger.kernel.org>,
       ALSA development <alsa-devel@alsa-project.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Rene Herman <rene.herman@gmail.com>,
       Krzysztof Helt <krzysztof.h1@wp.pl>
Subject: Re: [boot crash, bisected] in 9f240a55 "ALSA: opti93x: use cs4231
 lib"
References: <Pine.LNX.4.61.0807141105150.7676@tm8103-a.perex-int.cz>	<20080717170657.GA14593@elte.hu> <s5h3am8jqvy.wl%tiwai@suse.de>
In-Reply-To: <s5h3am8jqvy.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17-07-08 20:40, Takashi Iwai wrote:

> Could you try the patch below?

No, please hang on, it's much simpler. Above commit isn't actually 
itself guilty. Have a patch ready, but am testing a bit.

Rene.
