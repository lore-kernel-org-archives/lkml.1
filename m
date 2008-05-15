Return-Path: <linux-kernel-owner+w=401wt.eu-S1756341AbYEOKo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341AbYEOKo2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 06:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365AbYEOKoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 06:44:18 -0400
Received: from trinity.fluff.org ([89.145.97.151]:47599 "EHLO
	trinity.fluff.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbYEOKoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 06:44:17 -0400
X-Greylist: delayed 1673 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 May 2008 06:44:17 EDT
Date: Thu, 15 May 2008 11:16:38 +0100
To: Jean Delvare <khali@linux-fr.org>
Cc: Linux I2C <i2c@lm-sensors.org>, LKML <linux-kernel@vger.kernel.org>,
       Ben Dooks <ben-linux@fluff.org>
Subject: Re: [i2c] Wanted: i2c subsystem co-maintainer
Message-ID: <20080515101638.GC22585@trinity.fluff.org>
References: <20080304184512.3f78d296@hyperion.delvare> <20080325095028.07a73b11@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080325095028.07a73b11@hyperion.delvare>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.9i
From: Ben Dooks <ben@trinity.fluff.org>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 09:50:28AM +0100, Jean Delvare wrote:
> On Tue, 4 Mar 2008 18:45:12 +0100, Jean Delvare wrote:
> > I have a hard time maintaining the i2c subsystem alone. New drivers
> > and, more importantly, subsystem evolutions are submitted much faster
> > than I can review and merge them. I am hearing complaints about this.
> > It has been lasting for a while now and it doesn't seem like the
> > situation is going to improve. Thus, I think it would be better if
> > someone was co-maintaining the i2c subsystem with me.
> > 
> > So, if anyone is interested in co-maintaining the i2c subsystem with
> > me, please let me know. The ideal candidate would come from the
> > embedded world, as I have absolutely no experience with this myself and
> > most of the new drivers are for embedded devices, and should have
> > contributed to the kernel in a significant way already.
> 
> Ben Dooks agreed to become my co-maintainer for the i2c subsystem. In
> particular, Ben will help with drivers for embedded systems, of which
> my experience is inexistent. Thanks Ben and welcome on board!
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Ben Dooks <ben-linux@fluff.org>
> ---
> Ben, please give by your ack on this patch, then I will push it
> upstream.

Sorry, my main mailbox got hit by a major spam flood, have mostly
sorted this out now.

> 
>  MAINTAINERS |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- linux-2.6.25-rc6.orig/MAINTAINERS	2008-03-21 10:58:23.000000000 +0100
> +++ linux-2.6.25-rc6/MAINTAINERS	2008-03-23 15:16:11.000000000 +0100
> @@ -1883,6 +1883,8 @@ S:	Maintained
>  I2C SUBSYSTEM
>  P:	Jean Delvare
>  M:	khali@linux-fr.org
> +P:	Ben Dooks
> +M:	ben-linux@fluff.org
>  L:	i2c@lm-sensors.org
>  T:	quilt http://khali.linux-fr.org/devel/linux-2.6/jdelvare-i2c/
>  S:	Maintained
> 
> -- 
> Jean Delvare

-- 
-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

