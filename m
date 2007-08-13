Return-Path: <linux-kernel-owner+w=401wt.eu-S946479AbXHMPcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S946479AbXHMPcK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 11:32:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S973127AbXHMNaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 09:30:20 -0400
Received: from host03.cc-host.de ([193.138.108.23]:58621 "EHLO
	host03.cc-host.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S973128AbXHMNaQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 09:30:16 -0400
X-Greylist: delayed 2254 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Aug 2007 09:30:15 EDT
Date: Mon, 13 Aug 2007 14:51:45 +0200
From: Anders Larsen <al@alarsen.net>
Subject: Re: [PATCH] [397/2many] MAINTAINERS - QNX4 FILESYSTEM
To: joe@perches.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <46bffb7b.C++26gfic9//+SQA%joe@perches.com>
In-Reply-To: <46bffb7b.C++26gfic9//+SQA%joe@perches.com> (from
	joe@perches.com on Mon Aug 13 08:34:35 2007)
X-Mailer: Balsa 2.3.14
Message-Id: <1187009505l.26974l.0l@ecxwww1.reanet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-AEV-Kundenmail-Information: AEV Virus and Spam Secure Mail System
X-AEV-Kundenmail-SpamCheck: 
X-MailScanner-From: al@alarsen.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007-08-13 08:34:35, joe@perches.com wrote:
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6a99fe5..ed3be09 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3799,6 +3799,8 @@ M:	al@alarsen.net
>  L:	linux-kernel@vger.kernel.org
>  W:	http://www.alarsen.net/linux/qnx4fs/
>  S:	Maintained
> +F:	fs/qnx4
> +F:	include/linux/qnx4_fs.h

include/linux/qnxtypes.h too

Cheers
 Anders
