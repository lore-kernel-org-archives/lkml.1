Return-Path: <linux-kernel-owner+w=401wt.eu-S1757576AbXLSCMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576AbXLSCMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 21:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753711AbXLSCMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 21:12:08 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:12566 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbXLSCMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 21:12:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hBStWYn9kNRA9zaA23QbagCZWrcy/ovVDy68FIwtTHvzuA6DMp9OWfkdSv+2VGAk137rQDOkB+9V+2O4vTpgrQsw8rJCRU7I+HuyZIQl64KY+XscfvqgBkcjJP0abOIcoiW93Mv4jDmy/uby5+jTgrU7P8rRkvOYDX5yAZtXNss=
Message-ID: <520b60a90712181812l3fd6c4cbicece82a4487d0587@mail.gmail.com>
Date: Tue, 18 Dec 2007 21:12:05 -0500
From: mvtodevnull@gmail.com
To: "Larry Finger" <larry.finger@lwfinger.net>
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Michael Buesch" <mb@bu3sch.de>,
       "Daniel Walker" <dwalker@mvista.com>, "Ray Lee" <ray-lk@madrabbit.org>,
       "=?ISO-8859-1?Q?Simon_Holm_Th=F8gersen?=" <odie@cs.aau.dk>,
       matthias.kaehlcke@gmail.com, linux-kernel@vger.kernel.org,
       linux@bohmer.net, "Ingo Molnar" <mingo@elte.hu>, kjwinchester@gmail.com,
       jonathan@jonmasters.org, akpm@linux-foundation.org,
       bcm43xx-dev@lists.berlios.de
In-Reply-To: <520b60a90712171834n61b09f23rc4c907ce3e8458cf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071213003028.676998182@mvista.com>
	 <520b60a90712142037j14d54de5nf5657ab2927fb3f5@mail.gmail.com>
	 <520b60a90712142039t539faeddo68e73816fe1b3237@mail.gmail.com>
	 <47637FDA.2030303@lwfinger.net>
	 <520b60a90712150438p1f0ae40bt5975b494ab75203c@mail.gmail.com>
	 <520b60a90712161817uaa2d1a8y5dfb13b586ca30ad@mail.gmail.com>
	 <47661CA1.3080808@lwfinger.net>
	 <520b60a90712162317r5c2f2569gbd75c09742ff5493@mail.gmail.com>
	 <47671F5F.5020400@lwfinger.net>
	 <520b60a90712171834n61b09f23rc4c907ce3e8458cf@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Larry, thanks for being so patient so far. Tomorrow I plan to take my
laptop to somewhere with coffee and a wireless network. For now
though, can you tell me if these messages could be related:
PCI: Cannot allocate resource region 7 of bridge 0000:00:05.0
PCI: Cannot allocate resource region 8 of bridge 0000:00:05.0

or could tsc being marked as unstable have anything to do with the
speed of network transfers?
