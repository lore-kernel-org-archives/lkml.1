Return-Path: <linux-kernel-owner+w=401wt.eu-S1753249AbYH0GY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbYH0GY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 02:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbYH0GYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 02:24:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46785 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531AbYH0GYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 02:24:19 -0400
Date: Wed, 27 Aug 2008 08:24:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <greg@kroah.com>
Cc: Russ Anderson <rja@sgi.com>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, Jack Steiner <steiner@sgi.com>
Subject: Re: [PATCH] sysfs: Document files in /sys/firmware/sgi_uv/
Message-ID: <20080827062401.GA6255@elte.hu>
References: <20080826221402.GB173430@sgi.com> <20080827002219.GA29728@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080827002219.GA29728@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Greg KH <greg@kroah.com> wrote:

> On Tue, Aug 26, 2008 at 05:14:02PM -0500, Russ Anderson wrote:
> > Document files in /sys/firmware/sgi_uv/.
> > 
> > Signed-off-by: Russ Anderson <rja@sgi.com>
> 
> Looks good to me, thanks for doing this:
> 	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

applied to tip/x86/uv, thanks!

	Ingo
