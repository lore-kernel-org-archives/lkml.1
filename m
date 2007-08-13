Return-Path: <linux-kernel-owner+w=401wt.eu-S966712AbXHMMTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966712AbXHMMTl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967839AbXHMGnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:43:12 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:30630 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967831AbXHMGnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:43:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=OGos71h74wXpgrd3wOnmsihXT9Glsc3YbmgoJETQu2cy6zYJ7U7LmrW+tQGIzQh19Ddz6urHM2SFiRtOxvmcraofT6hN73jNq6Fw/D8pCZ3kQ2ov07Wp2gBa6kLgvD91UYuiI5lEyWw4H4qT1ueR66MXaAROrE85ucqAk/EnUIE=
Message-ID: <46BFFD76.9020909@gmail.com>
Date: Mon, 13 Aug 2007 10:43:02 +0400
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: joe@perches.com
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, astarikovskiy@suse.de,
       akpm@linux-foundation.org
Subject: Re: [PATCH] [23/2many] MAINTAINERS - ACPI BATTERY DRIVERS
References: <46bff88f.DlQUzlREkbeqr4cb%joe@perches.com>
In-Reply-To: <46bff88f.DlQUzlREkbeqr4cb%joe@perches.com>
X-Enigmail-Version: 0.94.2.0
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
> index 93a100b..6bb5785 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -261,6 +261,7 @@ M:	astarikovskiy@suse.de
>  L:	linux-acpi@vger.kernel.org
>  W:	http://acpi.sourceforge.net/
>  S:	Supported
> +F:	drivers/acpi/battery.c
>  
>  ACPI EC DRIVER
>  P:	Alexey Starikovskiy
> -
Please add *sbs* to the line.

Thanks,
Alex.
