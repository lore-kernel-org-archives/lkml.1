Return-Path: <linux-kernel-owner+w=401wt.eu-S1758317AbYIALoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758317AbYIALoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 07:44:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651AbYIALn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 07:43:56 -0400
Received: from mk-outboundfilter-3.mail.uk.tiscali.com ([212.74.114.23]:39074
	"EHLO mk-outboundfilter-3.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752506AbYIALnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 07:43:55 -0400
X-Trace: 164442104/mk-outboundfilter-1.mail.uk.tiscali.com/F2S/$F2S-NILDRAM-ACCEPTED/f2s-nildram-customers/195.149.44.6
X-SBRS: None
X-RemoteIP: 195.149.44.6
X-IP-MAIL-FROM: alistair@devzero.co.uk
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAHtyu0jDlSwG/2dsb2JhbACBZbEggWk
X-IronPort-AV: E=Sophos;i="4.32,307,1217804400"; 
   d="scan'208";a="164442104"
X-IP-Direction: IN
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Neil Brown <neilb@suse.de>
Subject: Re: md (regression): reboot/shutdown hangs
Date: Mon, 1 Sep 2008 12:43:50 +0100
User-Agent: KMail/1.10.0 (Linux/2.6.27-rc5-damocles; KDE/4.1.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <200808282005.09416.alistair@devzero.co.uk> <18619.20642.697691.541752@notabene.brown>
In-Reply-To: <18619.20642.697691.541752@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809011243.50300.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil,

On Monday 01 September 2008 03:17:06 Neil Brown wrote:
> On Thursday August 28, alistair@devzero.co.uk wrote:
> > Please let me know if there's any more information you need from me.
>
> Thanks for the report.
[snip]
> So I plan to remove it.  With it gone I cannot reproduce a hang.  If
> you can, I would love to hear about it.

I haven't tested it too much but it's passed a few reboots on this box which 
was previously hanging reliably. I think it would be OK to merge on top of 
2b25000bf5157c28d8591f03f0575248a8cbd900.

Thanks for the explanation and for the fix.

-- 
Cheers,
Alistair.
