Return-Path: <linux-kernel-owner+w=401wt.eu-S1753482AbYIUVML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbYIUVML (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 17:12:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbYIUVL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 17:11:56 -0400
Received: from relay.2ka.mipt.ru ([194.85.80.65]:41120 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752505AbYIUVLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 17:11:55 -0400
Date: Mon, 22 Sep 2008 01:10:40 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arjan van de Ven <arjan@infradead.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, ipw2100-devel@lists.sourceforge.net,
       linux-wireless@vger.kernel.org, yi.zhu@intel.com,
       reinette.chatre@intel.com, jgarzik@pobox.com, linville@tuxdriver.com,
       davem@davemloft.net
Subject: Re: Mark IPW2100 as BROKEN: Fatal interrupt. Scheduling firmware restart.
Message-ID: <20080921211038.GC2135@2ka.mipt.ru>
References: <20080921172316.GA6306@2ka.mipt.ru> <20080921110422.1d010b96@infradead.org> <20080921182835.GA11473@2ka.mipt.ru> <20080921113513.16677c4e@infradead.org> <20080921190050.GA20484@2ka.mipt.ru> <20080921205744.2d78f1fa@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080921205744.2d78f1fa@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 21, 2008 at 08:57:44PM +0100, Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> Try putting it into D3 counting to 10 and powering it back up. Thats
> about as close as you can get to pulling the plug when it hangs.

I will experiment with this, thanks Alan.
Unfortunately my machine builds this only
updated driver for about 10 minutes, so
results will appear not too quickly.
I will start tests tomorrow.

-- 
	Evgeniy Polyakov
