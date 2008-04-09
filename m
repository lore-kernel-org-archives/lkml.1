Return-Path: <linux-kernel-owner+w=401wt.eu-S1754340AbYDIGoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbYDIGoz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 02:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbYDIGor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 02:44:47 -0400
Received: from mail164.messagelabs.com ([216.82.253.131]:51640 "HELO
	mail164.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752519AbYDIGoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 02:44:46 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-14.tower-164.messagelabs.com!1207723480!13873434!21
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.21]
Date: Wed, 9 Apr 2008 08:35:30 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Cc: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: gpio patches in mmotm
Message-ID: <20080409063530.GA17538@digi.com>
References: <20080317173134.GA27282@digi.com> <Pine.LNX.4.64.0803171915020.8640@axis700.grange> <20080318160316.GA31588@digi.com> <Pine.LNX.4.64.0803181717240.5022@axis700.grange> <20080408060230.GA22071@digi.com> <Pine.LNX.4.64.0804080812420.3556@axis700.grange> <20080408093305.GA8141@digi.com> <Pine.LNX.4.64.0804081227360.4987@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0804081227360.4987@axis700.grange>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 09 Apr 2008 06:35:30.0730 (UTC) FILETIME=[E7FA08A0:01C89A0B]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.000.1023-15838.005
X-TM-AS-Result: No--12.852000-8.000000-2
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Guennadi,

Guennadi Liakhovetski wrote:
>                      My original proposal was to introduce just one 
> NO_GPIO macro to test against, however, David nicely managed to persuade 
> me, that the gpio_is_valid approach is better. Unfortunately, I cannot 
> argument as nicely as he did, maybe looking through his emails in LKML 
> archives will help you:-)
I'm unable to find these mails.  (Using gmane, looking for mails by
David matching gpio_is_valid, the oldest post I can find is
http://article.gmane.org/gmane.linux.kernel/637654.)

Can you please point out the discussion in the archives?

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
