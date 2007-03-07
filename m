Return-Path: <linux-kernel-owner+w=401wt.eu-S1030753AbXCGAFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030753AbXCGAFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 19:05:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030754AbXCGAFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 19:05:45 -0500
Received: from pne-smtpout3-sn2.hy.skanova.net ([81.228.8.111]:49711 "EHLO
	pne-smtpout3-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030753AbXCGAFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 19:05:44 -0500
Date: Wed, 7 Mar 2007 02:05:42 +0200
From: Sami Farin <7atbggg02@sneakemail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [RFC] div64_64 support
Message-ID: <20070307000542.u5vptpb7hgi4spo5@m.safari.iki.fi>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20070223170527.4ca695b2@freekitty> <20070305155714.3abe1b5e@freekitty> <20070306133404.GA864@one.firstfloor.org> <200703061519.20346.dada1@cosmosbay.com> <20070306144529.GA2004@one.firstfloor.org> <84C47260-4B57-4568-8197-58F438A6F737@e18.physik.tu-muenchen.de> <20070306102941.32471d57@freekitty> <20070306215349.hquin7d6pfy2n5d2@m.safari.iki.fi> <20070306222435.cbpv63ltximq6lrf@m.safari.iki.fi> <20070306160055.48b201a4@freekitty>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070306160055.48b201a4@freekitty>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2007 at 16:00:55 -0800, Stephen Hemminger wrote:
...
> > Now Linux 2.6 does not have "memory" in fls, maybe it causes
> > some gcc funnies some people are seeing.
> > 
> 
> That code was copy-paste from:
> 	include/asm-x86_64/bitops.h
> 
> So shouldn't both fls() and ffs() be fixed there as well?

Yes.  And for both x86_64 and i386.

-- 
