Return-Path: <linux-kernel-owner+w=401wt.eu-S1759036AbXKTMI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759036AbXKTMI7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 07:08:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756508AbXKTMIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 07:08:49 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:54689 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756306AbXKTMIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 07:08:48 -0500
Subject: Re: [v4l-dvb-maintainer] [PATCH 25/59] drivers/media/video: Add
	missing "space"
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Joe Perches <joe@perches.com>
Cc: Brandon Philips <bphilips@suse.de>, linux-kernel@vger.kernel.org,
       Stelian Pop <stelian@popies.net>,
       "LinuxTV.org Project" <v4l-dvb-maintainer@linuxtv.org>,
       video4linux-list@redhat.com
In-Reply-To: <1195531687.4675.73.camel@localhost>
References: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
	 <8cdb362d494c702f6f0cf095e8e24435550bf5ce.1195454435.git.joe@perches.com>
	 <20071120022442.GA17247@ifup.org>  <1195531687.4675.73.camel@localhost>
Content-Type: text/plain
Date: Tue, 20 Nov 2007 10:06:54 -0200
Message-Id: <1195560414.4718.29.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -180,7 +180,7 @@ void cx25840_vbi_setup(struct i2c_client *client)
>  						fsc/1000000,fsc%1000000);
>  
>  		v4l_dbg(1, cx25840_debug, client, "hblank %i, hactive %i, "
> -			"vblank %i , vactive %i, vblank656 %i, src_dec %i,"
> +			"vblank %i, vactive %i, vblank656 %i, src_dec %i, "

Ok, I've replaced the old hunk by the newer one you've just sent. I'm
committing the two drivers/media patches on my tree.

> 
-- 
Cheers,
Mauro

