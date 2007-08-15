Return-Path: <linux-kernel-owner+w=401wt.eu-S935775AbXHOTxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935775AbXHOTxG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 15:53:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758898AbXHOTww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 15:52:52 -0400
Received: from smtp3.hushmail.com ([65.39.178.135]:60821 "EHLO
	smtp3.hushmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758523AbXHOTwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 15:52:51 -0400
Date: Wed, 15 Aug 2007 15:52:42 -0400
To: <jirislaby@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
       <dri-devel@lists.sourceforge.net>
Subject: Re: [PATCH 4 of 5 ] /drivers/char/rio ioremap balancing/ returncode check
Reply-to: postfail@hushmail.com
From: "Scott Thompson" <postfail@hushmail.com>
Content-type: text/plain; charset="UTF-8"
Message-Id: <20070815195248.4A593C3821@mailserver10.hushmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 15 Aug 2007 15:38:23 -0400 Jiri Slaby <jirislaby@gmail.com> 
wrote:
>Ok. I was just curious, why did you CC drm people for char drivers 
>changes.
>
>BTW. is there anybody on janitors list, who collects all those 
>patches and
>forwards them upstream?
>

The "MAINTAINERS" list claims that there are "several" maintainers 
for the kernel-janitors submitted patches and the readme on 
kerneljanitors.org (http://www.kerneljanitors.org/README) lists a 
few folks.  Copying the originating maintainer/list is recommended 
in one of the kerneljanitor faqs. Some groups seem more receptive 
to these kind of fixes than others, though they may just be more 
active maintainers.  

I don't know if anyone does or doesn't roll these up collectively, 
maybe the list can advise...

---------------------------------------
Scott Thompson / postfail@hushmail.com
---------------------------------------

