Return-Path: <linux-kernel-owner+w=401wt.eu-S1755135AbYHJNvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135AbYHJNvx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 09:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbYHJNvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 09:51:45 -0400
Received: from mk-outboundfilter-4.mail.uk.tiscali.com ([212.74.114.32]:43644
	"EHLO mk-outboundfilter-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751469AbYHJNvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 09:51:44 -0400
X-Trace: 120886224/mk-outboundfilter-2.mail.uk.tiscali.com/F2S/$F2S-NILDRAM-ACCEPTED/f2s-nildram-customers/195.149.44.6
X-SBRS: None
X-RemoteIP: 195.149.44.6
X-IP-MAIL-FROM: alistair@devzero.co.uk
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AssHAGKPnkjDlSwG/2dsb2JhbACBX4EspWw
X-IronPort-AV: E=Sophos;i="4.31,338,1215385200"; 
   d="scan'208";a="120886224"
X-IP-Direction: IN
From: Alistair John Strachan <alistair@devzero.co.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #11197] Oops in microcode sysfs registration
Date: Sun, 10 Aug 2008 14:51:39 +0100
User-Agent: KMail/1.10.0 (Linux/2.6.27-rc2-damocles; KDE/4.1.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
References: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik> <cX_-nNkxKaF.A.GMD.oEjnIB@albercik> <200808101431.40147.alistair@devzero.co.uk>
In-Reply-To: <200808101431.40147.alistair@devzero.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808101451.39797.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 10 August 2008 14:31:40 Alistair John Strachan wrote:
> On Saturday 09 August 2008 23:43:50 Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.26.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11197
> > Subject		: Oops in microcode sysfs registration
> > Submitter	: Alistair John Strachan <alistair@devzero.co.uk>
> > Date		: 2008-07-29 13:57 (12 days old)
> > References	: http://marc.info/?t=121734004900002&r=1&w=4
> > Handled-By	: Dmitry Adamushko <dmitry.adamushko@gmail.com>
> > Patch		: http://marc.info/?l=linux-kernel&m=121741431005777&w=4
>
> It's still broken in -rc2 but I'll check -git in a minute. Dmitry posted an
> alternative set of patches but I don't know if they've been merged?

-git is still broken too, so it should definitely remain listed.

The patches to which I am referring are from here:
http://lkml.org/lkml/2008/8/3/114

-- 
Cheers,
Alistair.
