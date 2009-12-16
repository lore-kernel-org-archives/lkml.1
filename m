Return-Path: <linux-kernel-owner+w=401wt.eu-S1761323AbZLPKtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761323AbZLPKtm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 05:49:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755505AbZLPKtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 05:49:40 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:61951 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754370AbZLPKti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 05:49:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=qz1xicnzeUqYnCeWf0WIQaaImbXvjyo1X/BdIwuHrf9U++vDxtcK8AcmnG3cBs1Mjp
         gqLC7y3y2KLHl/stTgxSbXyqcXrGmUTRAWE0oMkawOUEYw7wMfvMtIef4lr855K6mDir
         tqL/BMXx0T+h58HRfi2PNPKtT/X7FSbsbh19Y=
Date: Wed, 16 Dec 2009 11:49:32 +0100
From: Stefan Seyfried <stefan.seyfried@googlemail.com>
To: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
Cc: Oliver Neukum <oliver@neukum.org>,
       Josua Dietze <digidietze@draisberghof.de>, linux-usb@vger.kernel.org,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH] move eject code from zd1211rw to usb-storage
Message-ID: <20091216114932.4bede511@strolchi.home.s3e.de>
In-Reply-To: <20091215180300.GF16426@one-eyed-alien.net>
References: <1260878800-14691-1-git-send-email-stefan.seyfried@googlemail.com>
	<4B278191.1010009@draisberghof.de>
	<200912151611.08576.oliver@neukum.org>
	<20091215180300.GF16426@one-eyed-alien.net>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.1; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Dec 2009 10:03:00 -0800
Matthew Dharm <mdharm-kernel@one-eyed-alien.net> wrote:
> The right answer here is neither to move the eject code nor to introduce
> more of it.  New devices should be supported via userspace.

Can somebody point me to the "userspace" that is meant here?
Preferably some code that can be built actually?
-- 
Stefan Seyfried

"Any ideas, John?"
"Well, surrounding them's out."
