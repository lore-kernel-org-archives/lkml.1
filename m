Return-Path: <linux-kernel-owner+w=401wt.eu-S1753451AbZLMN63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbZLMN63 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 08:58:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753428AbZLMN62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 08:58:28 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60662 "HELO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753430AbZLMN61 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 08:58:27 -0500
Date: Sun, 13 Dec 2009 14:58:18 +0100
From: Pavel Machek <pavel@ucw.cz>
To: liu weni <qingshenlwy@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Toralf F?rster <toralf.foerster@gmx.de>
Subject: Re: [PATCH v2]kernel: remove mess codes
Message-ID: <20091213135818.GB1511@ucw.cz>
References: <b3657a100912122255j138bb9e6s785bdc8152a27691@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <b3657a100912122255j138bb9e6s785bdc8152a27691@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-12-13 14:55:40, liu weni wrote:
> I found some mess characters(0x0c) in the kernel source code.
> Then I suggest remove it.
> Thanks for Toralf Förster's support.
> This patch include the following 40 files:

> Signed-off-by: Liuwenyi<qingshenlwy@gmail.com>
> Signed-off-by: Toralf Förster<toralf.foerster@gmx.de>
> ----
> diff --git a/COPYING b/COPYING
> index ca442d3..0dde99b 100644
> --- a/COPYING
> +++ b/COPYING
> @@ -71,7 +71,7 @@ patent must be licensed for everyone's free use or
> not licensed at all.
> 
>    The precise terms and conditions for copying, distribution and
>  modification follow.
> -
> +
>  		    GNU GENERAL PUBLIC LICENSE
>     TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
> 

I do not think you may modify GPL. NAK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
