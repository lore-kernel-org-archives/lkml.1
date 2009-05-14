Return-Path: <linux-kernel-owner+w=401wt.eu-S1757976AbZENQ3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976AbZENQ3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 12:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbZENQ3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 12:29:21 -0400
Received: from mail09.linbit.com ([212.69.161.110]:52323 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbZENQ3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 12:29:20 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: Neil Brown <neilb@suse.de>
Subject: Re: Contrasting DRBD with md/nbd
Date: Thu, 14 May 2009 18:29:19 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>, linux-kernel@vger.kernel.org,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       "Lars Marowsky-Bree" <lmb@suse.de>
References: <18955.47806.365247.808127@notabene.brown>
In-Reply-To: <18955.47806.365247.808127@notabene.brown>
X-OTRS-FollowUp-SenderType: agent
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905141829.20221.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 May 2009 08:31:26 Neil Brown wrote:
> [ cc: list massively trimmed compared to original posting of code and
>   subsequent discussion..]
>
> Hi,
>
>  Prior to giving DRBD a proper review I've been trying to make sure
>  that I understand it, so I have a valid model to compare the code
>  against (and so I can steal any bits that I like for md:-)
>
[...]
>  Thank you for reading.  I found the exercise educational.  I hope you
>  did too.  I think I  might even be ready to review the DRBD code now :-)
>

In fact I read the whole thing, I mostly agree. Maybe there are a view
glitches in, but I do not take it as challenge to find those.

I appreciate that you took you time to really understand what DRBD does. 
I assume you read some of the papers we published.

BTW, I intend to send the code for a further round of review tomorrow.

-Phil
-- 
: Dipl-Ing Philipp Reisner
: LINBIT | Your Way to High Availability
: Tel: +43-1-8178292-50, Fax: +43-1-8178292-82
: http://www.linbit.com

DRBD(R) and LINBIT(R) are registered trademarks of LINBIT, Austria.

