Return-Path: <linux-kernel-owner+w=401wt.eu-S1751848AbZGTPBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbZGTPBA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 11:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751625AbZGTPA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 11:00:59 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34268 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbZGTPA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 11:00:58 -0400
Date: Mon, 20 Jul 2009 10:59:34 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Noah Watkins <jayhawk@soe.ucsc.edu>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: regression: wireless authentication
Message-ID: <20090720145934.GD2775@tuxdriver.com>
References: <20090717035706.GA5923@martini> <20090717141047.7ce77136.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090717141047.7ce77136.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 17, 2009 at 02:10:47PM +1000, Stephen Rothwell wrote:
> Hi Noah,
> 
> Lets cc some people who may be able to help ...
> 
> On Thu, 16 Jul 2009 20:57:06 -0700 Noah Watkins <jayhawk@soe.ucsc.edu> wrote:
> >
> > With 2.6.31-rc3-next-20090716 all wireless access points are detected, but
> > authentication fails. I haven't verified on an access point w/o WPA.
> > 
> > 2.6.31-rc3 functions fine. I haven't been able to complete a bisect yet.
> > 
> > 05:01.0 Network controller: Atheros Communications Inc. AR5008 Wireless Network
> > Adapter (rev 01)

Odd...have you (i.e. Noah) been using -next trees all along?  What was
the last previous one that worked?  I didn't push anything out for
-next to pick-up all last week...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
			¡Viva Honduras Libre!
