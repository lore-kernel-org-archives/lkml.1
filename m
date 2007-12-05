Return-Path: <linux-kernel-owner+w=401wt.eu-S1754286AbXLESCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbXLESCX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 13:02:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbXLESCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 13:02:15 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:53206 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbXLESCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 13:02:14 -0500
Subject: Re: [build bug] undefined reference to
	`dib3000mc_get_tuner_i2c_master'
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jiri Kosina <jikos@jikos.cz>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Patrick Boettcher <pb@linuxtv.org>,
       Marcel Holtmann <marcel@holtmann.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <Pine.LNX.4.64.0712051132340.2935@twin.jikos.cz>
References: <20071204083904.GA15694@elte.hu>
	 <Pine.LNX.4.64.0712041130310.16564@twin.jikos.cz>
	 <20071204105439.GA20175@elte.hu>
	 <Pine.LNX.4.64.0712051132340.2935@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Date: Wed, 05 Dec 2007 16:01:53 -0200
Message-Id: <1196877713.4646.10.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Em Qua, 2007-12-05 às 11:33 +0100, Jiri Kosina escreveu:
> On Tue, 4 Dec 2007, Ingo Molnar wrote:
> 
> > > Hmm, seems like -common part contains also code that is not completely 
> > > common to all the modules.
> > > How about this?
> > that does the trick and 2.6.24-rc4 now builds & boots fine with that 
> > config. Thanks,
> > Tested-by: Ingo Molnar <mingo@elte.hu>
> 
> Mauro, Patrick, are you going to take it through your trees, or should I 
> push it through akpm?

Jiri/Ingo,

I'll take care of this patch.

-- 
Cheers,
Mauro

