Return-Path: <linux-kernel-owner+w=401wt.eu-S1755620AbZDNV1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620AbZDNV1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 17:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbZDNV1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 17:27:31 -0400
Received: from [213.79.90.228] ([213.79.90.228]:5823 "EHLO
	buildserver.ru.mvista.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751630AbZDNV1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 17:27:31 -0400
Date: Wed, 15 Apr 2009 01:27:24 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: subrata@linux.vnet.ibm.com, sachinp <sachinp@linux.vnet.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linuxppc-dev <Linuxppc-dev@ozlabs.org>,
       linux-next <linux-next@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>,
       Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: [BUILD FAILURE 11/12] Next April 14 : PPC64 randconfig
	[drivers/spi/mpc52xx_psc_spi.c]
Message-ID: <20090414212724.GA12371@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <1239733836.5344.83.camel@subratamodak.linux.ibm.com> <fa686aa40904141142s3717812ep293973fefce8853d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <fa686aa40904141142s3717812ep293973fefce8853d@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 12:42:47PM -0600, Grant Likely wrote:
> Thanks Subrata.  I'll look into this.

Whoops. That's my fault, I didn't expect that anyone other
than spi_mpc83xx is using fsl_spi_platform_data. :-/

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
