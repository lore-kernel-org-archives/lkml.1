Return-Path: <linux-kernel-owner+w=401wt.eu-S1755464AbYIJV5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbYIJV5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 17:57:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbYIJV44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 17:56:56 -0400
Received: from mail.kernelconcepts.de ([212.60.202.196]:54899 "EHLO
	mail.kernelconcepts.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbYIJV4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 17:56:55 -0400
X-Greylist: delayed 2741 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Sep 2008 17:56:55 EDT
Message-ID: <48C837B2.8020106@kernelconcepts.de>
Date: Wed, 10 Sep 2008 23:10:10 +0200
From: Nils Faerber <nils.faerber@kernelconcepts.de>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<ukleinek@informatik.uni-freiburg.de>
CC: linux-kernel@vger.kernel.org, Thomas Woller <twoller@crystal.cirrus.com>,
       Nils Faerber <nils@kernelconcepts.de>
Subject: Re: [PATCH] Reformat MAINTAINERS entry for Cirrus CS4280/CS461X sound
 driver
References: <20080910193210.GA26173@informatik.uni-freiburg.de> <1221076300-7018-1-git-send-email-ukleinek@informatik.uni-freiburg.de>
In-Reply-To: <1221076300-7018-1-git-send-email-ukleinek@informatik.uni-freiburg.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
Thanks, I am fine with this change too.

Cheers
  nils


Uwe Kleine-König schrieb:
> replace the (anyhow obvious) company name by Thomas' realname and remove
> Nils' realname from his M field which is already in the corresponding P
> field.
> 
> The old entry broke my script to merge the P and M fields.
> 
> Signed-off-by: Uwe Kleine-König <ukleinek@informatik.uni-freiburg.de>
> Cc: Thomas Woller <twoller@crystal.cirrus.com>
> Cc: Nils Faerber <nils@kernelconcepts.de>
> ---
>  MAINTAINERS |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 186be3b..fdea0d3 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1113,10 +1113,10 @@ L:	alsa-devel@alsa-project.org
>  S:	Supported
>  
>  CIRRUS LOGIC CS4280/CS461x SOUNDDRIVER
> -P:	Cirrus Logic Corporation (kernel 2.2 driver)
> -M:	Cirrus Logic Corporation, Thomas Woller <twoller@crystal.cirrus.com>
> +P:	Thomas Woller (kernel 2.2 driver)
> +M:	twoller@crystal.cirrus.com
>  P:	Nils Faerber (port to kernel 2.4)
> -M:	Nils Faerber <nils@kernelconcepts.de>
> +M:	nils@kernelconcepts.de
>  S:	Maintained
>  
>  CODA FILE SYSTEM


-- 
kernel concepts GbR      Tel: +49-271-771091-12
Sieghuetter Hauptweg 48  Fax: +49-271-771091-19
D-57072 Siegen           Mob: +49-176-21024535
http://www.kernelconcepts.de
