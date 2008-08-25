Return-Path: <linux-kernel-owner+w=401wt.eu-S1754769AbYHYIkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbYHYIkA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 04:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653AbYHYIjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 04:39:51 -0400
Received: from ns1.suse.de ([195.135.220.2]:47941 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281AbYHYIjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 04:39:51 -0400
Date: Mon, 25 Aug 2008 10:39:48 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Yinghai Lu <yhlu.kernel@gmail.com>, Vivek Goyal <vgoyal@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: only put e820 ram entries in resource tree
Message-ID: <20080825103948.6ba5757c@halley.suse.de>
In-Reply-To: <1219617897-9870-1-git-send-email-yhlu.kernel@gmail.com>
References: <1219617897-9870-1-git-send-email-yhlu.kernel@gmail.com>
Organization: SUSE Linux Products GmbH
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
X-Face: ,G!z)dEOMkc[Cu+sF64,T9^5r3b>/}#HBRL%D^j@\SZbr'Itl7q@1<*dgB?A7(_leO1Tc4^
 D*WfvfwKcz;,@E^y+pNP%86n8o<&g-vToCXW:r>Y$jxY,`KT?{H!07=2|Jdt?0ba^C-Tnx50vIV8It
 vi&Sicl:sj`k2`y)E;ECFi;i7W-?t3%\kD*));q)+%-pQd^.r'W}oBBx=+.~Gu}&F;lS7.a-m>Rv"w
 pe`D'OV^?HJd$-)7<2T[naDPl6+bAj'+UYd]u]B^'.LYK$2jS
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Yinghai Lu [2008-08-24 15:44]:
>
> may need user to have new kexec tools that could create e820 table
> from /sys/firmware/memmap instead of /proc/iomem for second kernel

2.0.0 has that implemented.



Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
