Return-Path: <linux-kernel-owner+w=401wt.eu-S1757156AbZEBPP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156AbZEBPP3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 11:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbZEBPPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 11:15:20 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57155 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbZEBPPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 11:15:19 -0400
Date: Sat, 2 May 2009 17:15:15 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH 2/2] ftrace: add function-graph tracer support for ARM
	v2
Message-ID: <20090502151515.GA10418@pengutronix.de>
References: <49FB79CF.3020101@am.sony.com> <20090502001100.GH6404@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090502001100.GH6404@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> Also I wonder how far we are from the dynamic ftrace support, which seems
> half implemented or broken or not tested for a while?
Commit 07c4cc1cdaa08fcb6c0275dd7be49eae37260169 suggests that "the new
MCOUNT_RECORD method" needs to be implemented.  I don't know the
details, though (yet).

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
