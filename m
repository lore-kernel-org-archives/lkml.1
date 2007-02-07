Return-Path: <linux-kernel-owner+w=401wt.eu-S1030565AbXBGTNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030565AbXBGTNJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 14:13:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030640AbXBGTNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 14:13:09 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:47058 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030565AbXBGTNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 14:13:08 -0500
From: Ismail =?iso-8859-1?q?D=F6nmez?= <ismail@pardus.org.tr>
Organization: TUBITAK/UEKAE
To: Levitsky Maxim <maximlevitsky@yahoo.com>
Subject: Re: [PATCH] [NET] dmfe : number of fixes and features
Date: Wed, 7 Feb 2007 21:13:02 +0200
User-Agent: KMail/1.9.6
References: <131364.59702.qm@web38502.mail.mud.yahoo.com>
In-Reply-To: <131364.59702.qm@web38502.mail.mud.yahoo.com>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702072113.02951.ismail@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Wednesday 07 February 2007 19:57:21 you wrote:
> Hello,
>
> Before some time I decided to fix suspend/resume on my Davicom network
> card. During development I also fixed couple of bugs and added support for
> link detection and WOL Note : 2.6.20 already has support for link detection
> , but it is broken when card has external PHY , like mine.
>
> So here it goes:
>
> [PATCH] [NET] [001] dmfe : trivial/spelling fixes
> [PATCH] [NET] [002] dmfe : Fix possible oops
> [PATCH] [NET] [003] dmfe : fix link detection
> [PATCH] [NET] [004] dmfe : Add suspend/resume support
> [PATCH] [NET] [005] dmfe : Add support for wake-on-lan


CC netdev@vger.kernel.org for network patches.

Regards,
ismail
