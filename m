Return-Path: <linux-kernel-owner+w=401wt.eu-S1756695Ab0A2LdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695Ab0A2LdV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 06:33:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227Ab0A2LdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 06:33:20 -0500
Received: from smtp.nokia.com ([192.100.105.134]:45680 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab0A2LdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 06:33:20 -0500
Subject: Re: UBIFS assert failed in ubifs_dirty_inode
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jeff Angielski <jeff@theptrgroup.com>, Matt Mackall <mpm@selenic.com>,
       linux-mtd@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100129112757.GA1309@gondor.apana.org.au>
References: <4B591573.60602@theptrgroup.com>
	 <1264480808.2401.78.camel@localhost.localdomain>
	 <1264484928.3536.1017.camel@calx> <1264500214.3867.21.camel@localhost>
	 <4B5F9A78.7080000@theptrgroup.com> <1264558433.3536.1543.camel@calx>
	 <4B5FADE8.30803@theptrgroup.com>
	 <1264566010.2401.143.camel@localhost.localdomain>
	 <20100129112757.GA1309@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jan 2010 13:32:09 +0200
Message-ID: <1264764729.4371.12.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 29 Jan 2010 11:32:53.0570 (UTC) FILETIME=[CBC65A20:01CAA0D6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-29 at 22:27 +1100, Herbert Xu wrote:
> On Wed, Jan 27, 2010 at 06:20:10AM +0200, Artem Bityutskiy wrote:
> >
> > Thanks for testing. So, who would bring Matt's patch upstream then, hmm?
> 
> I've got it in crypto-2.6.  Thanks!

I'd appreciate an URL.

I've just cloned:

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6

and do not see it there.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

