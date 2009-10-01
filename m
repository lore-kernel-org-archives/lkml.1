Return-Path: <linux-kernel-owner+w=401wt.eu-S932119AbZJAI0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119AbZJAI0N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755980AbZJAI0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:26:10 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40145 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973AbZJAI0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:26:05 -0400
Date: Thu, 1 Oct 2009 10:26:07 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 00/35] fix usage of __{,dev}exit_p
Message-ID: <20091001082607.GA2181@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I already sent a similar series in January[1].  Apart from a general Ack
by Sam there was no reaction.  

Now that there exists scripts/get_maintainer.pl, I resend an updated
series to an wider audience in the hope to get more feedback.

Best regards
Uwe

[1] http://thread.gmane.org/gmane.linux.kernel/779241

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
