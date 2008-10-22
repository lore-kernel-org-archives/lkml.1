Return-Path: <linux-kernel-owner+w=401wt.eu-S1755258AbYJVKAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbYJVKAI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 06:00:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbYJVJ74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 05:59:56 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:41747 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbYJVJ7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 05:59:55 -0400
Date: Wed, 22 Oct 2008 11:59:43 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Jean-Marc Spaggiari" <jean-marc@spaggiari.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH] Allow it87.c to handle IT8720
Message-ID: <20081022115943.1fd9d7d6@hyperion.delvare>
In-Reply-To: <20081007223623.684281f2@hyperion.delvare>
References: <79c9d4530810061033g3630dc2dwabb4d3c2a3f17337@mail.gmail.com>
	<20081007223623.684281f2@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean-Marc,

On Tue, 7 Oct 2008 22:36:23 +0200, Jean Delvare wrote:
> Hi Jean-Marc,
> 
> On Mon, 6 Oct 2008 13:33:56 -0400, Jean-Marc Spaggiari wrote:
> > The goal of this patch is to allow it87.c to handle IT8720 chipset
> > like IT8718 in order to retreive voltage, temperatures and fans speed
> > from sensors tools.
> > 
> > JMS
> > 
> > Patch also attached.
> > 
> > --- linux-2.6.27-rc8/drivers/hwmon/it87.c.orig  2008-10-02 09:04:44.000000000 -0400
> > +++ linux-2.6.27-rc8/drivers/hwmon/it87.c       2008-10-06 13:27:08.000000000 -0400
> > @@ -14,6 +14,7 @@

<snip, me reviewing the patch>

> Other than that - and the lack of Signed-off-by line - your patch looks
> OK to me.

Any chance to have an updated patch from you by the end of the day, so
that it makes it into kernel 2.6.28? The merge window is closing really
soon now.

-- 
Jean Delvare
