Return-Path: <linux-kernel-owner+w=401wt.eu-S1756730AbXL2KRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730AbXL2KRs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 05:17:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752998AbXL2KRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 05:17:39 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:45965 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752695AbXL2KRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 05:17:38 -0500
Message-ID: <398923461.28353@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Sat, 29 Dec 2007 18:17:29 +0800
From: WU Fengguang <wfg@mail.ustc.edu.cn>
To: Sascha Warner <prx@cinatas.ath.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 00/11] writeback bug fixes and simplifications
References: <47742268.8040302@cinatas.ath.cx> <20071228150111.e9451632.akpm@linux-foundation.org> <47747B3A.5090304@cinatas.ath.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47747B3A.5090304@cinatas.ath.cx>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.17 (2007-11-01)
Message-Id: <E1J8Ykz-0002zC-8Z@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2007 at 05:27:38AM +0100, Sascha Warner wrote:
> Andrew Morton wrote:
> > On Thu, 27 Dec 2007 23:08:40 +0100 Sascha Warner <prx@cinatas.ath.cx> wrote:
> >
> >   
> >> Hi,
> >>
> >> I applied your patches to 2.6.24-rc6-mm1, but now I am faced with one
> >> pdflush often using 100% CPU for a long time. There seem to be some rare
> >> pauses from its 100% usage, however.
> >>
> >> On ~23 minutes uptime i have ~19 minutes pdflush runtime.
> >>
> >> This is on E6600, x86_64, 2 Gig RAM, SATA HDD, running on gentoo ~x64_64
> >>
> >> Let me know if you need more info.
> >>
> >>     
> >
> > (some) cc's restored.  Please, always do reply-to-all.
> >   
> Hi Wu,
> 
> Your latest patch does fix the seen pdflush 100% issue :)

Thank you.

Andrew: I'll be off line for some days.
The patchset will be updated some time later.

Happy new year~

Fengguang

