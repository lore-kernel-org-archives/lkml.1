Return-Path: <linux-kernel-owner+w=401wt.eu-S933382AbZLKFur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933382AbZLKFur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 00:50:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756669AbZLKFup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 00:50:45 -0500
Received: from smtp.nokia.com ([192.100.122.230]:25866 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756132AbZLKFuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 00:50:44 -0500
Subject: Re: [GIT PULL]: OMAP2/3 Display Subsystem
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, tony@atomide.com,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       linux-fbdev@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@nokia.com>
In-Reply-To: <1260377610.9700.49.camel@tubuntu.research.nokia.com>
References: <1260377610.9700.49.camel@tubuntu.research.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Dec 2009 07:49:55 +0200
Message-Id: <1260510595.12346.148.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 11 Dec 2009 05:50:11.0238 (UTC) FILETIME=[CD6DBC60:01CA7A25]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-09 at 18:53 +0200, Tomi Valkeinen wrote:
> Linus,
> 
> Here are the new display subsystem and framebuffer drivers for OMAP2/3.
> 
> The drivers have been reviewed on linux-omap and linux-fbdev-devel, and
> are in use, for example, on N900, Beagle Board and Overo boards.
> 
> The drivers are actively maintained and developed further, and I have
> already a bunch of patches on top of these patches, but I would like to
> get the big core driver merged first. After the core drivers are merged,
> other people can send patches to LCD drivers and board files to enable
> the new display subsystem on their boards.
> 
> Please pull the new OMAP2/3 display subsystem drivers from:
> 
>   git://gitorious.org/linux-omap-dss2/linux.git for-linus
> 
>  Tomi

Hi Linus,

I'd like to confirm that DSS2 is used in Nokia both internally and in
production, namely in N900. Other people use it in production as well,
e.g. Gumstix.

DSS2 is basically de-facto standard display sub-system in the OMAP3
world. It is mature, well-written and maintained, being around for at
least 1+ year, and open from almost very beginning.

ACK and Tested-by from my side. The OMAP maintainer (Tony) gave his Ack
as well as many other people, e.g., in this thread:

http://marc.info/?l=linux-kernel&m=125146241831217&w=2

DSS2 is in linux-next for some time as well.

Thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

