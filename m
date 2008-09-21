Return-Path: <linux-kernel-owner+w=401wt.eu-S1752958AbYIUVM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbYIUVM3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 17:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbYIUVMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 17:12:05 -0400
Received: from relay.2ka.mipt.ru ([194.85.80.65]:41122 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753099AbYIUVMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 17:12:03 -0400
Date: Mon, 22 Sep 2008 01:05:55 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Johannes Berg <johannes@sipsolutions.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, ipw2100-devel@lists.sourceforge.net,
       linux-wireless@vger.kernel.org, yi.zhu@intel.com,
       reinette.chatre@intel.com, jgarzik@pobox.com, linville@tuxdriver.com,
       davem@davemloft.net
Subject: Re: Mark IPW2100 as BROKEN: Fatal interrupt. Scheduling firmware restart.
Message-ID: <20080921210554.GA2135@2ka.mipt.ru>
References: <20080921182835.GA11473@2ka.mipt.ru> <20080921113513.16677c4e@infradead.org> <20080921190050.GA20484@2ka.mipt.ru> <1222024444.3023.53.camel@johannes.berg> <20080921193809.GA8735@2ka.mipt.ru> <20080921124332.67ddc13a@infradead.org> <20080921202057.GB25052@2ka.mipt.ru> <20080921132753.5689b564@infradead.org> <20080921205706.GA24545@2ka.mipt.ru> <20080921140203.4698a2ee@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080921140203.4698a2ee@infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 21, 2008 at 02:02:03PM -0700, Arjan van de Ven (arjan@infradead.org) wrote:
> > That allows to dump whatever number of warnings you want. The more we
> > have, the louder will be customers scream.
> 
> artificially increasing numbers isn't going to do that; it just shows
> you're more interested in making a stink than in getting something
> improved ;(

As practice shows, I'm the only one who is interested in getting
something improved, and Intel, as we see right now, is not interested in
it at all, since you ask me not only decrease error verbosity, but also
do not work towards fixing the bug by trying to understand where it
lives.

-- 
	Evgeniy Polyakov
