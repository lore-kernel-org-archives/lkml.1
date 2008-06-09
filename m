Return-Path: <linux-kernel-owner+w=401wt.eu-S1757059AbYFIIDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059AbYFIIDO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 04:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754334AbYFIIC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 04:02:58 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:30718 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754291AbYFIIC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 04:02:57 -0400
Date: Mon, 9 Jun 2008 17:00:46 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Uwe Kleine-K?nig <Uwe.Kleine-Koenig@digi.com>
Cc: "Hans J. Koch" <hjk@linutronix.de>, Magnus Damm <magnus.damm@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH] uio_pdrv: Unique IRQ Mode
Message-ID: <20080609080046.GA11605@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Uwe Kleine-K?nig <Uwe.Kleine-Koenig@digi.com>,
	"Hans J. Koch" <hjk@linutronix.de>,
	Magnus Damm <magnus.damm@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>
References: <20080604060826.17162.46972.sendpatchset@rx1.opensource.se> <20080604101144.GA3207@local> <aec7e5c30806041825o4c6c859fp8380063e9384622@mail.gmail.com> <20080605090916.GA3198@local> <aec7e5c30806050246t248abc39vbc1e71d4475a0a0d@mail.gmail.com> <20080605112744.GB3198@local> <aec7e5c30806080319y7b9b6a89icacbfa67b117fb2b@mail.gmail.com> <20080608205455.GA3191@local> <20080609075701.GA20656@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080609075701.GA20656@digi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2008 at 09:57:01AM +0200, Uwe Kleine-K?nig wrote:
>  - rename "Unique IRQ Mode" to something like "No IRQ Handler Mode".
>    I'm not completely lucky with that name, but it's better than the
>    former.  Of course the function should be renamed accordingly.
> 
User IRQ mode?
