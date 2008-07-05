Return-Path: <linux-kernel-owner+w=401wt.eu-S1755177AbYGEGOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbYGEGOZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 02:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbYGEGOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 02:14:16 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:55721 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500AbYGEGOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 02:14:15 -0400
Message-ID: <486F112E.5090001@garzik.org>
Date: Sat, 05 Jul 2008 02:14:06 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Takashi Iwai <tiwai@suse.de>, Hugh Dickins <hugh@veritas.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, mchan@broadcom.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org
Subject: Re: [bug?] tg3: Failed to load firmware "tigon/tg3_tso.bin"
References: <20080703020236.adaa51fa.akpm@linux-foundation.org>	 <20080703205548.D6E5.KOSAKI.MOTOHIRO@jp.fujitsu.com>	 <486CC440.9030909@garzik.org>	 <Pine.LNX.4.64.0807031353030.11033@blonde.site>	 <s5hmykxc3ja.wl%tiwai@suse.de>	 <1215177471.10393.753.camel@pmac.infradead.org>	 <s5hej69lqzk.wl%tiwai@suse.de>  <486E28BB.1030205@garzik.org>	 <1215179126.10393.771.camel@pmac.infradead.org>	 <486E2F68.2000707@garzik.org> <1215180802.10393.783.camel@pmac.infradead.org>
In-Reply-To: <1215180802.10393.783.camel@pmac.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> I'm working on making the required firmware get installed as part of
> 'make modules_install'.

Great!  That will definitely reduce silent regressions due to build 
process changes.

	Jeff


