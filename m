Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008Ab0CLUo2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 15:44:28 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35017 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757208Ab0CLUo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 15:44:27 -0500
Date: Fri, 12 Mar 2010 20:44:20 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: akpm@linux-foundation.org
Cc: ken_kawasaki@spring.nifty.jp, linux-kernel@vger.kernel.org
Subject: Re: +
	firmware-correct-attribution-of-sierra-wireless-cis-files.patch
	added to -mm tree
Message-ID: <20100312204420.GO2763@decadent.org.uk>
References: <201003122035.o2CKZdoD006510@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003122035.o2CKZdoD006510@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 12:35:39PM -0800, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      firmware: correct attribution of Sierra Wireless CIS files
> has been added to the -mm tree.  Its filename is
>      firmware-correct-attribution-of-sierra-wireless-cis-files.patch
[...]
> +Driver: SERIAL_8250_CS - Serial PCMCIA adapter
> +
> +File: cis/SW_555_SER.cis
> +File: cis/SW_7xx_SER.cis
> +File: cis/SW_8xx_SER.cis
> +
> +Licence: Unknown
[...]

The licence actually appears to be GPLv3, so this patch should be replaced
with the version in <http://article.gmane.org/gmane.linux.kernel/958246/raw>.
 
Ben.

-- 
Ben Hutchings
If God had intended Man to program,
we'd have been born with serial I/O ports.
