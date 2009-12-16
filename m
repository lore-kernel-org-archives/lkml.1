Return-Path: <linux-kernel-owner+w=401wt.eu-S934872AbZLPOPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934872AbZLPOPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 09:15:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934169AbZLPOP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 09:15:29 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55005 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934071AbZLPOP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 09:15:29 -0500
Date: Wed, 16 Dec 2009 09:05:43 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Stefan Seyfried <stefan.seyfried@googlemail.com>
Cc: Josua Dietze <digidietze@draisberghof.de>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH] move eject code from zd1211rw to usb-storage
Message-ID: <20091216140542.GB11793@tuxdriver.com>
References: <1260878800-14691-1-git-send-email-stefan.seyfried@googlemail.com> <4B278191.1010009@draisberghof.de> <200912151611.08576.oliver@neukum.org> <20091215180300.GF16426@one-eyed-alien.net> <20091216114932.4bede511@strolchi.home.s3e.de> <4B28C2F7.7040207@draisberghof.de> <20091216131452.49ad183b@strolchi.home.s3e.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091216131452.49ad183b@strolchi.home.s3e.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 01:14:52PM +0100, Stefan Seyfried wrote:
> On Wed, 16 Dec 2009 12:22:31 +0100
> Josua Dietze <digidietze@draisberghof.de> wrote:
> 
> > Stefan Seyfried schrieb:
> > > Preferably some code that can be built actually?
> > 
> > If the "eject" from SCSI tools does not work, "usb_modeswitch" can 
> > send customized bulk messages to devices.
> 
> for my device, eject seems to be enough, so I'll be trying to get
> this into udev.

When you do that any chance you could account for zd1211rw too? :-)

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
