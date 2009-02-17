Return-Path: <linux-kernel-owner+w=401wt.eu-S1754206AbZBQR2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbZBQR2m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 12:28:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692AbZBQR2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 12:28:34 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:39099 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbZBQR2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 12:28:33 -0500
Date: Tue, 17 Feb 2009 18:28:20 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Frank Seidel <frank@f-seidel.de>
Cc: Frank Seidel <fseidel@suse.de>,
       linux kernel <linux-kernel@vger.kernel.org>, rlove@rlove.org,
       lm-sensors@lm-sensors.org
Subject: Re: [PATCHv2] MAINTAINERS: switch hdaps to Frank Seidel
Message-ID: <20090217182820.1ac46c01@hyperion.delvare>
In-Reply-To: <49982084.80609@f-seidel.de>
References: <49980A67.7030403@suse.de>
	<49982084.80609@f-seidel.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frank,

On Sun, 15 Feb 2009 15:02:44 +0100, Frank Seidel wrote:
> From: Frank Seidel <frank@f-seidel.de>
> 
> As Rovert Love doesn't any more seem to be realy
> active on hdaps driver i'll happily take it over.
> 
> Signed-off-by: Frank Seidel <frank@f-seidel.de>
> ---
>  MAINTAINERS |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1905,10 +1905,10 @@ W:	http://gigaset307x.sourceforge.net/
>  S:	Maintained
>  
>  HARD DRIVE ACTIVE PROTECTION SYSTEM (HDAPS) DRIVER
> -P:	Robert Love
> -M:	rlove@rlove.org
> -M:	linux-kernel@vger.kernel.org
> -W:	http://www.kernel.org/pub/linux/kernel/people/rml/hdaps/
> +P:	Frank Seidel
> +M:	frank@f-seidel.de
> +M:	lm-sensors@lm-sensors.org
> +W:	http://www.kernel.org/pub/linux/kernel/people/fseidel/hdaps

It looks like you accidentally created directory hsdpa instead of hdaps?

>  S:	Maintained
>  
>  GSPCA FINEPIX SUBDRIVER
> 


-- 
Jean Delvare
