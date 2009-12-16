Return-Path: <linux-kernel-owner+w=401wt.eu-S1762098AbZLPLXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762098AbZLPLXM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 06:23:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762099AbZLPLXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 06:23:03 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:47263 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762098AbZLPLW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 06:22:59 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Stefan Seyfried <stefan.seyfried@googlemail.com>
Subject: Re: [PATCH] move eject code from zd1211rw to usb-storage
Date: Wed, 16 Dec 2009 12:23:16 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Josua Dietze <digidietze@draisberghof.de>, linux-usb@vger.kernel.org,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       usb-storage@lists.one-eyed-alien.net
References: <1260878800-14691-1-git-send-email-stefan.seyfried@googlemail.com> <20091215180300.GF16426@one-eyed-alien.net> <20091216114932.4bede511@strolchi.home.s3e.de>
In-Reply-To: <20091216114932.4bede511@strolchi.home.s3e.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912161223.16403.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 16. Dezember 2009 11:49:32 schrieb Stefan Seyfried:
> On Tue, 15 Dec 2009 10:03:00 -0800
> Matthew Dharm <mdharm-kernel@one-eyed-alien.net> wrote:
> > The right answer here is neither to move the eject code nor to introduce
> > more of it.  New devices should be supported via userspace.
> 
> Can somebody point me to the "userspace" that is meant here?
> Preferably some code that can be built actually?

Sure:
http://www.draisberghof.de/usb_modeswitch/

	HTH
		Oliver
