Return-Path: <linux-kernel-owner+w=401wt.eu-S1756557AbYG2RP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557AbYG2RP1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 13:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbYG2RPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 13:15:17 -0400
Received: from mk-outboundfilter-5.mail.uk.tiscali.com ([212.74.114.1]:16019
	"EHLO mk-outboundfilter-5.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750933AbYG2RPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 13:15:16 -0400
X-Trace: 63183161/mk-outboundfilter-5.mail.uk.tiscali.com/F2S/$F2S-NILDRAM-ACCEPTED/f2s-nildram-customers/195.149.44.6
X-SBRS: None
X-RemoteIP: 195.149.44.6
X-IP-MAIL-FROM: alistair@devzero.co.uk
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ak0GADvtjkjDlSwG/2dsb2JhbACBW4lEpgg
X-IronPort-AV: E=Sophos;i="4.31,273,1215385200"; 
   d="scan'208";a="63183161"
X-IP-Direction: IN
From: Alistair John Strachan <alistair@devzero.co.uk>
To: "Marco Berizzi" <pupilla@hotmail.com>
Subject: Re: commit a29ccf6f823a84d89e1c7aaaf221cf7282022024 break console on slackware 12.1
Date: Tue, 29 Jul 2008 18:15:13 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org, tim.bird@am.sony.com
References: <BAY103-DAV4F0ECBCAFB86B24C87D3EB2820@phx.gbl>
In-Reply-To: <BAY103-DAV4F0ECBCAFB86B24C87D3EB2820@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807291815.13907.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 July 2008 16:42:54 Marco Berizzi wrote:
> Hi Folks,
>
> reverting commit a29ccf6f823a84d89e1c7aaaf221cf7282022024
> fix a problem with the text console on slackware 12.1
>
> With 2.6.27-rc1/slackware 12.1, applications like
> mc or 'make menuconfig' are broken on text console
> (they are fine running inside an xterm).
>
> Just for record: 2.6.26 is fine

You don't actually say whether you had CONFIG_CONSOLE_TRANSLATIONS=y or not?

(Added some relevant people to CC.)

-- 
Cheers,
Alistair.
