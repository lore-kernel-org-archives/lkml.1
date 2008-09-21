Return-Path: <linux-kernel-owner+w=401wt.eu-S1753464AbYIUVCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464AbYIUVCT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 17:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbYIUVCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 17:02:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:56371 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbYIUVCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 17:02:08 -0400
Date: Sun, 21 Sep 2008 14:02:03 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Johannes Berg <johannes@sipsolutions.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, ipw2100-devel@lists.sourceforge.net,
       linux-wireless@vger.kernel.org, yi.zhu@intel.com,
       reinette.chatre@intel.com, jgarzik@pobox.com, linville@tuxdriver.com,
       davem@davemloft.net
Subject: Re: Mark IPW2100 as BROKEN: Fatal interrupt. Scheduling firmware
 restart.
Message-ID: <20080921140203.4698a2ee@infradead.org>
In-Reply-To: <20080921205706.GA24545@2ka.mipt.ru>
References: <20080921172316.GA6306@2ka.mipt.ru>
	<20080921110422.1d010b96@infradead.org>
	<20080921182835.GA11473@2ka.mipt.ru>
	<20080921113513.16677c4e@infradead.org>
	<20080921190050.GA20484@2ka.mipt.ru>
	<1222024444.3023.53.camel@johannes.berg>
	<20080921193809.GA8735@2ka.mipt.ru>
	<20080921124332.67ddc13a@infradead.org>
	<20080921202057.GB25052@2ka.mipt.ru>
	<20080921132753.5689b564@infradead.org>
	<20080921205706.GA24545@2ka.mipt.ru>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2008 00:57:06 +0400
Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:

> > > Consider for inclusing for the upcoming kernel to get wider
> > > notifications. Yes, it is not a bugfix, I know.
> > 
> > still more complex than needed; a WARN_ON_ONCE() will be enough.
> 
> That allows to dump whatever number of warnings you want. The more we
> have, the louder will be customers scream.

artificially increasing numbers isn't going to do that; it just shows
you're more interested in making a stink than in getting something
improved ;(

> 


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
