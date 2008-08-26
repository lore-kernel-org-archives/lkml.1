Return-Path: <linux-kernel-owner+w=401wt.eu-S1757246AbYHZIUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246AbYHZIUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 04:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbYHZIU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 04:20:29 -0400
Received: from mail.suse.de ([195.135.220.2]:57879 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752200AbYHZIU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 04:20:28 -0400
Date: Tue, 26 Aug 2008 10:20:23 +0200
From: Bernhard Walle <bwalle@suse.de>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Vivek Goyal" <vgoyal@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: only put e820 ram entries in resource tree
Message-ID: <20080826102023.2d7cd1c3@halley.suse.de>
In-Reply-To: <86802c440808251013u20533707w692b5ba94e32e9c9@mail.gmail.com>
References: <1219617897-9870-1-git-send-email-yhlu.kernel@gmail.com>
	<20080825103948.6ba5757c@halley.suse.de>
	<86802c440808251013u20533707w692b5ba94e32e9c9@mail.gmail.com>
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

* Yinghai Lu [2008-08-25 10:13]:
>
> On Mon, Aug 25, 2008 at 1:39 AM, Bernhard Walle <bwalle@suse.de> wrote:
> > * Yinghai Lu [2008-08-24 15:44]:
> >>
> >> may need user to have new kexec tools that could create e820 table
> >> from /sys/firmware/memmap instead of /proc/iomem for second kernel
> >
> > 2.0.0 has that implemented.
>
> Yes
> 
> can you guys make kexec-tools 2.0.0 can be complied to static as one option?

See http://article.gmane.org/gmane.linux.kernel.kexec/2223.



Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
