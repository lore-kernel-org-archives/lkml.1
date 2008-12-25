Return-Path: <linux-kernel-owner+w=401wt.eu-S1752121AbYLYOAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbYLYOAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 09:00:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbYLYOAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 09:00:46 -0500
Received: from mk-outboundfilter-3.mail.uk.tiscali.com ([212.74.114.23]:40013
	"EHLO mk-outboundfilter-3.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751524AbYLYOAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 09:00:45 -0500
X-Trace: 207794314/mk-outboundfilter-1.mail.uk.tiscali.com/F2S/$F2S-NILDRAM-ACCEPTED/f2s-nildram-customers/195.149.44.6/None/alistair@devzero.co.uk
X-SBRS: None
X-RemoteIP: 195.149.44.6
X-IP-MAIL-FROM: alistair@devzero.co.uk
X-MUA: KMail/1.10.3 (Linux/2.6.28-rc8-damocles; KDE/4.1.3; x86_64; ; )
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqgEACchU0nDlSwG/2dsb2JhbACBbLxBWJAOhkQ
X-IronPort-AV: E=Sophos;i="4.36,281,1228089600"; 
   d="scan'208";a="207794314"
X-IP-Direction: IN
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Sami Farin <safari-kernel@safari.iki.fi>
Subject: Re: Happy v2.6.28
Date: Thu, 25 Dec 2008 14:00:42 +0000
User-Agent: KMail/1.10.3 (Linux/2.6.28-rc8-damocles; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Hans Lambrechts <hans.lambrechts@skynet.be>
References: <bMLNZ-3QM-1@gated-at.bofh.it> <200812250853.mBP8rxrr004080@server.home.lan> <20081225131402.ldo5rtovjvftgada@m.safari.iki.fi>
In-Reply-To: <20081225131402.ldo5rtovjvftgada@m.safari.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812251400.42602.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 December 2008 13:14:02 Sami Farin wrote:
> On Thu, Dec 25, 2008 at 09:53:59 +0100, Hans Lambrechts wrote:
> > Dec 25 09:30:45 server kernel: Pid: 5918, comm: sendmail Tainted: G     
> > D (2.6.28 #60)
>
> Can you try without proprietary modules?

For a start, there weren't any proprietary modules in his module list, and 
secondly, "G" means that all modules loaded are GPL.

  1: 'G' if all modules loaded have a GPL or compatible license, 'P' if
     any proprietary module has been loaded.  Modules without a
     MODULE_LICENSE or with a MODULE_LICENSE that is not recognised by
     insmod as GPL compatible are assumed to be proprietary.

  8: 'D' if the kernel has died recently, i.e. there was an OOPS or BUG.

(See Documentation/oops-tracing.txt).

-- 
Cheers,
Alistair.
