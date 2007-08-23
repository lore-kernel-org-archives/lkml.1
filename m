Return-Path: <linux-kernel-owner+w=401wt.eu-S1765374AbXHWRil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765374AbXHWRil (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 13:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759478AbXHWRic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 13:38:32 -0400
Received: from straum.hexapodia.org ([64.81.70.185]:14065 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759442AbXHWRib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 13:38:31 -0400
Date: Thu, 23 Aug 2007 10:38:30 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: K Naru <squat_rack@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Patch 2.6.22.2 ,2nd try] : ./drivers/net/via-rhine.c: Offload checksum handling to VT6105M
Message-ID: <20070823173830.GA23688@hexapodia.org>
References: <517544.547.qm@web53812.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <517544.547.qm@web53812.mail.re2.yahoo.com>
User-Agent: Mutt/1.4.2.2i
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2007 at 12:54:17PM -0700, K Naru wrote:
> --- ./drivers/net/via-rhine.c.orig      2007-08-09
> 14:28:15.000000000 -0700
> +++ ./drivers/net/via-rhine.c   2007-08-20
> 04:29:43.000000000 -0700
[snip]
> +#define TDES1_TCPCK    0x00100000  /* Bit 20,
> Transmit Desc 1  */
> +#define TDES1_UDPCK    0x00080000  /* Bit 19,
> Transmit Desc 1  */     
> +#define TDES1_IPCK     0x00040000  /* Bit 18,

Your patch is very badly word-wrapped.  Please fix your mailer, and then
test by sending the patch to yourself and applying the result.

-andy
