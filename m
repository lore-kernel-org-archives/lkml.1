Return-Path: <linux-kernel-owner+w=401wt.eu-S1751583AbZHLENV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751583AbZHLENV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 00:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751041AbZHLENU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 00:13:20 -0400
Received: from mail-yw0-f191.google.com ([209.85.211.191]:36850 "EHLO
	mail-yw0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbZHLENT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 00:13:19 -0400
X-Greylist: delayed 56924 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Aug 2009 00:13:19 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=deXtQPXzM2v/V/km3VpCJB48/yQQCn7dLt+YcJOY5tzDpCqFBI+0GhscDj9nu5QJQa
         yuhhZNyZuLPvuuWF4X1XsXUr0DAQZprGJuanzvKnQ9cXEpan+NX117EN0yc0NPapzQZi
         DrGrjgFSmpqSchsVrBJ7IvqFQk3I9H5VYsZMM=
MIME-Version: 1.0
In-Reply-To: <20090729170510.GD4803@oksana.dev.rtsoft.ru>
References: <20090729170345.GA26787@oksana.dev.rtsoft.ru> <20090729170510.GD4803@oksana.dev.rtsoft.ru>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 12 Aug 2009 00:12:55 -0400
Message-ID: <8bd0f97a0908112112m2e97c71do722199fdce476231@mail.gmail.com>
Subject: Re: [PATCH 4/7] spi: Prefix modalias with "spi:"
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       David Woodhouse <dwmw2@infradead.org>,
       Grant Likely <grant.likely@secretlab.ca>,
       Jean Delvare <khali@linux-fr.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       linuxppc-dev@ozlabs.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 13:05, Anton Vorontsov wrote:
> This makes it consistent with other buses (platform, i2c, vio, ...).
> I'm not sure why we use the prefixes, but there must be a reason.
>
> This was easy enough to do it, and I did it.

acked-by-me for misc blackfin/adi drivers, thanks
-mike
