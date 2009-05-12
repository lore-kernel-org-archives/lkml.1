Return-Path: <linux-kernel-owner+w=401wt.eu-S1755361AbZELJOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbZELJOf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 05:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751174AbZELJOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 05:14:25 -0400
Received: from cpsmtpm-eml105.kpnxchange.com ([195.121.3.9]:59155 "EHLO
	CPSMTPM-EML105.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751013AbZELJOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 05:14:25 -0400
From: Frans Pop <elendil@planet.nl>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [madwifi-project] Death to MadWifi!
Date: Tue, 12 May 2009 11:14:21 +0200
User-Agent: KMail/1.9.9
Cc: p0g0@madwifi-project.org, madwifi-project@venema.h4ckr.net,
       Cliff.Holden@atheros.com, mb@bu3sch.de, nbd@openwrt.org,
       mickflemm@gmail.com, proski@gnu.org, me@bobcopeland.com,
       juhosg@openwrt.org, linux-kernel@vger.kernel.org
References: <43e72e890905111627r54fd4fa4r26d9511c1fd625a2@mail.gmail.com> <4A0908AB.1070606@madwifi-project.org> <4A0908AB.1070606@madwifi-project.org> <43e72e890905112332j3e32fb8q942fb75f882b2384@mail.gmail.com>
In-reply-To: <43e72e890905112332j3e32fb8q942fb75f882b2384@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905121114.24355.elendil@planet.nl>
X-OriginalArrivalTime: 12 May 2009 09:14:24.0642 (UTC) FILETIME=[0B0A0E20:01C9D2E2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis R. Rodriguez wrote:
> Trust me, I'm not concerned at all -- reason for me sending this
> e-mail was having to hear a rant from a user about MadWifi being such
> crap and about devices not being supported properly.

Let me give at least one counter example.

I have used madwifi in the past but switched to ath5k when it came 
available for my old Trust Atheros-based PCMCIA card, mostly because of 
the ease of compilation and partly because of the better "free-ness".

There is at least one area where the madwifi driver was and probably still 
is far superior: properly blinking the leds on the card to show the 
power/connection state and during data transfer.

It's not a major issue and though I've mentioned this at least once in a 
bug report or mail, this admittedly was back when there were more 
important things to fix. I probably should submit a proper bug report 
about it now.

I'm not asking for this to be fixed with this mail. I only mention it 
because the title and tone of this mail, and the fact of its recurring 
theme, offend me somewhat.
The way FOSS normally works is that one variant of alternative software 
will gradually die a natural death once a clear superior is established. 
There should be no need for members of rival projects to try to actively 
kill eachother off (the rival project that is, not its members).

Cheers,
FJP

P.S. This is the only post I've seen from this thread as apparently it 
started somewhere other than LKML.
