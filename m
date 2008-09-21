Return-Path: <linux-kernel-owner+w=401wt.eu-S1752767AbYIUTVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbYIUTVU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 15:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbYIUTVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 15:21:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:39905 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbYIUTVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 15:21:03 -0400
Date: Sun, 21 Sep 2008 12:20:48 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Wei Weng <wweng@acedsl.com>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, ipw2100-devel@lists.sourceforge.net,
       linux-wireless@vger.kernel.org, yi.zhu@intel.com,
       reinette.chatre@intel.com, jgarzik@pobox.com, linville@tuxdriver.com,
       davem@davemloft.net
Subject: Re: Mark IPW2100 as BROKEN: Fatal interrupt. Scheduling firmware
 restart.
Message-ID: <20080921122048.2bd52541@infradead.org>
In-Reply-To: <48D697F5.9050802@acedsl.com>
References: <20080921172316.GA6306@2ka.mipt.ru>
	<20080921110422.1d010b96@infradead.org>
	<20080921182835.GA11473@2ka.mipt.ru>
	<20080921113513.16677c4e@infradead.org>
	<48D697F5.9050802@acedsl.com>
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

On Sun, 21 Sep 2008 14:52:37 -0400
Wei Weng <wweng@acedsl.com> wrote:
> > again.. so how about you detect this condition and do, in the driver
> > code, the equivalent of rmmod/insmod to the hardware. I'm sure
> > people who have the hardware would appreciate that type of patch a
> > lot more than the one you sent out.
> > 
> 
> I guess it is your way of "middle finger" to all the IPW2100
> customers who try to use it on a Linux machine.

if suggesting a workaround is giving the middle finger in your mind, 
then I don't think it's worth my time to discuss this further with you.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
