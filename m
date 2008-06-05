Return-Path: <linux-kernel-owner+w=401wt.eu-S1753827AbYFEGuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbYFEGuB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 02:50:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbYFEGtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 02:49:51 -0400
Received: from mail37.messagelabs.com ([216.82.244.163]:47810 "EHLO
	mail37.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298AbYFEGtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 02:49:51 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-14.tower-37.messagelabs.com!1212648589!1584110!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.14]
Date: Thu, 5 Jun 2008 08:49:45 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Magnus Damm <magnus.damm@gmail.com>
CC: "Hans J. Koch" <hjk@linutronix.de>, <linux-kernel@vger.kernel.org>,
       <gregkh@suse.de>, <akpm@linux-foundation.org>, <lethal@linux-sh.org>,
       <tglx@linutronix.de>
Subject: Re: [PATCH] uio_pdrv: Unique IRQ Mode
Message-ID: <20080605064945.GA32554@digi.com>
References: <20080604060826.17162.46972.sendpatchset@rx1.opensource.se> <20080604101144.GA3207@local> <aec7e5c30806041825o4c6c859fp8380063e9384622@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aec7e5c30806041825o4c6c859fp8380063e9384622@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 05 Jun 2008 06:49:46.0360 (UTC) FILETIME=[57848F80:01C8C6D8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Magnus,

Magnus Damm wrote:
> ... "Unique IRQ Mode". ...
BTW, I wouldn't call it "Unique IRQ Mode" because the non-shared irq is
only a result from automatically disabling the irq.  IMHO something like
"No IRQ Handler Mode" is more suitable.

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
