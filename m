Return-Path: <linux-kernel-owner+w=401wt.eu-S1754069AbZFFIp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbZFFIp2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 04:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbZFFIpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 04:45:20 -0400
Received: from smtp3.netcologne.de ([194.8.194.66]:50750 "EHLO
	smtp3.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbZFFIpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 04:45:18 -0400
X-Greylist: delayed 2020 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Jun 2009 04:45:18 EDT
From: Mathias Kretschmer <posting@blx4.net>
Organization: BLX4
To: Mike Dresser <mdresser_l@windsormachine.com>
Subject: Re: [Bug #13375] Kernel crash with 2.6.29 + nfs + xfs (radix-tree)
Date: Sat, 6 Jun 2009 10:11:30 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.30-rc8; KDE/4.2.4; i686; ; )
Cc: Christoph Hellwig <hch@infradead.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alex Samad <alex@samad.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Chinner <david@fromorbit.com>
References: <THxQaUP0K2D.A.QkF.UVbIKB@chimera> <20090605093234.GA30705@infradead.org> <alpine.DEB.1.10.0906051115580.16086@router.windsormachine.com>
In-Reply-To: <alpine.DEB.1.10.0906051115580.16086@router.windsormachine.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906061011.34124.posting@blx4.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 June 2009 17:19:06 Mike Dresser wrote:
> On Fri, 5 Jun 2009, Christoph Hellwig wrote:
> > I haven't actually measured it, but it shouldn't be that bad.  Mostly
>
> I've enabled that as of yesterday and I'll let it go through it's normal
> operations.. It did survive the other night without CONFIG_XFS_DEBUG
> on(and on 2.6.30-rc8), but that sometimes happened anyways.

Is your machine still happy ?

If so, I'll give 2.6.30-rc8 a shot, as well.

-Mathias

> If it makes it through this weekend without crashing then that bodes well
> for something being fixed in the recent rc's.
>
> Doesn't seem to be any slower though, the backups completed around the
> same time as they always do.
>
> Mike
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

