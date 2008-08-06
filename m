Return-Path: <linux-kernel-owner+w=401wt.eu-S1754974AbYHFMzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbYHFMzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 08:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbYHFMzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 08:55:36 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59110 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312AbYHFMzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 08:55:32 -0400
Date: Wed, 6 Aug 2008 14:14:52 +0200
From: Pavel Machek <pavel@suse.cz>
To: Austin Zhang <austin_zhang@linux.intel.com>
Cc: herbert@gondor.apana.org.au, bunk@kernel.org, dwmw2@infradead.org,
       davem@davemloft.net, randy.dunlap@oracle.com,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c
	algorithm by new crypto API -V3.
Message-ID: <20080806121452.GA22459@elf.ucw.cz>
References: <1218000211.4231.23.camel@localhost.localdomain> <20080806094226.GA23685@atrey.karlin.mff.cuni.cz> <1218020727.29030.16.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218020727.29030.16.camel@localhost.localdomain>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-08-06 07:05:27, Austin Zhang wrote:
> Paval,
> 
> Thanks for your comments. 
> 
> On Wed, 2008-08-06 at 11:42 +0200, Pavel Machek wrote:
> > Copyright / GPL?
> Yes, as : ???+MODULE_LICENSE("GPL");

Well, it should normally go to comment at the beggining of file.

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
