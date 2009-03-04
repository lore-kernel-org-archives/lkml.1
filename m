Return-Path: <linux-kernel-owner+w=401wt.eu-S1756066AbZCDLrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbZCDLrt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 06:47:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbZCDLrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 06:47:40 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:49593 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809AbZCDLrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 06:47:39 -0500
Subject: Re: [patch/rfc 2.6.29-rc6 2/2] regulator: twl4030 voltage
 enumeration (v2)
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Mark Brown <broonie@sirena.org.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
In-Reply-To: <200903031500.00166.david-b@pacbell.net>
References: <200902081037.06645.david-b@pacbell.net>
	 <200902261602.58832.david-b@pacbell.net>
	 <1235737930.31223.117.camel@vega.slimlogic.co.uk>
	 <200903031500.00166.david-b@pacbell.net>
Content-Type: text/plain
Date: Wed, 04 Mar 2009 11:47:36 +0000
Message-Id: <1236167256.6781.4.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-03 at 14:59 -0800, David Brownell wrote:
> On Friday 27 February 2009, Liam Girdwood wrote:
> > Sorry, this didn't apply. It looks like I'm missing an earlier patch(s)
> > here. Could you regenerate this and your core patch against latest
> > for-next.
> 
> Here you go.
> 
> - Dave
> 
> 
> ========== CUT HERE
> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> Minor cleanups to the twl403 regulator driver, mostly enabled
> by other recent changes:  comments, shrink memory usage, add
> definition for one bit.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> ---
>  drivers/regulator/twl4030-regulator.c |   16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
> 

Applied.

Thanks

Liam

