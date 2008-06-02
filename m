Return-Path: <linux-kernel-owner+w=401wt.eu-S1759410AbYFBLSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759410AbYFBLSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 07:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266AbYFBLS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 07:18:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57793 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687AbYFBLSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 07:18:25 -0400
Date: Mon, 2 Jun 2008 13:18:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 08 of 12] xen-console: add save/restore
Message-ID: <20080602111805.GA19980@elte.hu>
References: <patchbomb.1211550067@localhost> <d9561e802a69a3ca269c.1211550075@localhost> <20080602111720.GC18586@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080602111720.GC18586@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0259]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> -tip testing found the following xen-console symbols trouble:
> 
>  ERROR: "console_drivers" [drivers/video/xen-fbfront.ko] undefined!
>  ERROR: "get_phys_to_machine" [drivers/video/xen-fbfront.ko] undefined!
>  ERROR: "get_phys_to_machine" [drivers/net/xen-netfront.ko] undefined!
>  ERROR: "get_phys_to_machine" [drivers/input/xen-kbdfront.ko] undefined!
> 
> with:
> 
>   http://redhat.com/~mingo/misc/config-Mon_Jun__2_12_26_38_CEST_2008.bad

that would be:

  http://redhat.com/~mingo/misc/config-Mon_Jun__2_12_25_13_CEST_2008.bad

	Ingo
