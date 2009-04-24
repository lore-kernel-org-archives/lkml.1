Return-Path: <linux-kernel-owner+w=401wt.eu-S1758576AbZDXGd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576AbZDXGd2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 02:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757432AbZDXGdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 02:33:19 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33118 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755823AbZDXGdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 02:33:18 -0400
Date: Fri, 24 Apr 2009 08:32:59 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-arm@lists.arm.linux.org.uk
Subject: Re: [PATCH] Add function graph tracer support for ARM
Message-ID: <20090424063259.GA9502@pengutronix.de>
References: <49F0AEA2.5010309@am.sony.com> <20090423192022.GA5976@nowhere> <49F0ECCC.70202@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49F0ECCC.70202@am.sony.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 03:33:48PM -0700, Tim Bird wrote:
> > I don't know which tree would be the best to rebase this work on, 
> > whether ARM or -tip. But anyway it should really be based against
> > a 2.6.30 development tree.
> Are you talking about -tip of Linus' tree, or is there a
> tracing tree I should getting stuff from?
git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
