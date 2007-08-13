Return-Path: <linux-kernel-owner+w=401wt.eu-S1030936AbXHMNA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030936AbXHMNA5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S943001AbXHMIKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 04:10:42 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:58115 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S943079AbXHMIKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 04:10:37 -0400
Message-ID: <46C011FB.9080109@s5r6.in-berlin.de>
Date: Mon, 13 Aug 2007 10:10:35 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: joe@perches.com
CC: torvalds@linux-foundation.org, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, krh@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH] [198/2many] MAINTAINERS - FIREWIRE SUBSYSTEM
References: <46bff9ed.Ya9JdXR0dvc3Ionf%joe@perches.com>
In-Reply-To: <46bff9ed.Ya9JdXR0dvc3Ionf%joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

joe@perches.com wrote:
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 9aa822a..18dfe29 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1895,12 +1895,15 @@ S:	Maintained
>  F:	fs/*
>  
>  FIREWIRE SUBSYSTEM
> -P:	Kristian Hoegsberg, Stefan Richter
> -M:	krh@redhat.com, stefanr@s5r6.in-berlin.de
> +P:	Kristian Hoegsberg
> +M:	krh@redhat.com
> +P:	Stefan Richter
> +M:	stefanr@s5r6.in-berlin.de
>  L:	linux1394-devel@lists.sourceforge.net
>  W:	http://www.linux1394.org/
>  T:	git kernel.org:/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
>  S:	Maintained
> +F:	drivers/ieee/1394/

Wrong path.

>  
>  FIRMWARE LOADER (request_firmware)
>  L:	linux-kernel@vger.kernel.org


+F:	drivers/firewire/
+F:	include/linux/firewire-*.h

-- 
Stefan Richter
-=====-=-=== =--- -==-=
http://arcgraph.de/sr/
