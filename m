Return-Path: <linux-kernel-owner+w=401wt.eu-S1752503AbXCUPRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbXCUPRs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 11:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752971AbXCUPRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 11:17:48 -0400
Received: from keetweej.vanheusden.com ([213.84.46.114]:36621 "EHLO
	keetweej.vanheusden.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbXCUPRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 11:17:47 -0400
Date: Wed, 21 Mar 2007 16:17:45 +0100
From: Folkert van Heusden <folkert@vanheusden.com>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Neil Brown <neilb@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       "J. Bruce Fields" <bfields@fieldses.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Re: [2.6.20] BUG: workqueue leaked lock
Message-ID: <20070321151745.GG741@vanheusden.com>
References: <17918.11420.155569.991473@notabene.brown> <20070320093753.GA1751@ff.dom.local> <20070320160759.GA107@tv-sign.ru> <20070321080510.GA1939@ff.dom.local> <20070321144620.GC78@tv-sign.ru> <20070321151651.GA4547@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070321151651.GA4547@ff.dom.local>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Reply-By: Sun Mar 18 00:02:24 CET 2007
X-Message-Flag: PGP key-id: 0x1f28d8ae - consider encrypting your e-mail to me with PGP!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I thought you are trying to diagnose a bug and maybe Folkert could test,
> if this patch makes any difference. Sorry, if I missed the real problem.

Yes please let me know when I can test a patch.


Folkert van Heusden

-- 
www.biglumber.com <- site where one can exchange PGP key signatures 
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
