Return-Path: <linux-kernel-owner+w=401wt.eu-S1753997AbYLJSl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbYLJSl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 13:41:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755542AbYLJSlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 13:41:17 -0500
Received: from mail.queued.net ([207.210.101.209]:2641 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755003AbYLJSlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 13:41:15 -0500
Date: Wed, 10 Dec 2008 13:41:11 -0500
From: Andres Salomon <dilinger@queued.net>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jeremy Katz <katzj@redhat.com>, jordan@cosmicpenguin.net,
       Pavel Machek <pavel@suse.cz>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jordan Crouse <jordan.crouse@amd.com>, linux-kernel@vger.kernel.org,
       dsaxena@laptop.org
Subject: Re: [PATCH] ALSA: cs5535audio: only build OLPC support if MGEODE_LX
 is defined
Message-ID: <20081210134111.1c67466d@ephemeral>
In-Reply-To: <s5hbpvkdlg3.wl%tiwai@suse.de>
References: <1226547898.13077.83.camel@aglarond.local>
	<s5h63msru7z.wl%tiwai@suse.de>
	<20081113153714.GA1520@ucw.cz>
	<s5h3ahvhb9w.wl%tiwai@suse.de>
	<20081113111428.59aa36cb@ephemeral>
	<20081113163802.GA1734@ucw.cz>
	<20081113120147.2ecde3c8@ephemeral>
	<20081113190339.GE17851@elte.hu>
	<s5hzlk3kxuf.wl%tiwai@suse.de>
	<20081113213852.16561ed2@ephemeral>
	<20081114075248.GB8397@atrey.karlin.mff.cuni.cz>
	<491DB6B9.7030209@cosmicpenguin.net>
	<1226688350.13086.61.camel@aglarond.local>
	<20081114161035.786f89ba@ephemeral>
	<s5hbpvkdlg3.wl%tiwai@suse.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2008 17:49:48 +0100
Takashi Iwai <tiwai@suse.de> wrote:
[...]
> This is really a workaround, and I hope the GPIO stuff will be
> fixed in arch/x86 in a better way...
> 
> 
> thanks,
> 
> Takashi


Sorry, I'm still working on it, but it's slow going.  Note that I'm no
longer contracted by OLPC, so I'll be working on it in my free time.
