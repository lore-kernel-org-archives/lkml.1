Return-Path: <linux-kernel-owner+w=401wt.eu-S1757010AbYGKIQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757010AbYGKIQr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 04:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756609AbYGKIQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 04:16:33 -0400
Received: from main.gmane.org ([80.91.229.2]:48276 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756347AbYGKIQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 04:16:30 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Subject: Re: [PATCH 15/15] regulator: maintainers - add maintainers for  
 regulator framework (new for V5)
Date: Fri, 11 Jul 2008 11:16:16 +0300
Message-ID: <487716D0.2020003@teltonika.lt>
References: <1215703671.13431.71.camel@odin>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 82-135-208-232.static.zebra.lt
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
In-Reply-To: <1215703671.13431.71.camel@odin>
Cc: linux-arm-kernel@lists.arm.linux.org.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Liam Girdwood wrote:
> Adds Liam Girdwood and Mark Brown as regulator framework maintainers.
> 
> Signed-off-by: Liam Girdwood <lg@opensource.wolfsonmicro.com>
> ---
>  MAINTAINERS |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6476125..551d231 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4424,6 +4424,15 @@ M:	kaber@trash.net
>  L:	netdev@vger.kernel.org
>  S:	Maintained
>  
> +VOLTAGE AND CURRENT REGULATOR FRAMEWORK
> +P:	Liam Girdwood
> +M:	lg@opensource.wolfsonmicro.com
> +P:	Mark Brown
> +M:	broonie@opensource.wolfsonmicro.com
> +W:	http://opensource.wolfsonmicro.com/node/15
> +T:	git opensource.wolfsonmicro.com:/linux-2.6-audioplus.git

Shouldn't this be:
git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git

> +S:	Supported
> +
>  VT1211 HARDWARE MONITOR DRIVER
>  P:	Juerg Haefliger
>  M:	juergh@gmail.com

