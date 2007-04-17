Return-Path: <linux-kernel-owner+w=401wt.eu-S1754420AbXDQOhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420AbXDQOhy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 10:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754432AbXDQOhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 10:37:53 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:6275 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420AbXDQOhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 10:37:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=JEFQWmu7IR1KNOThLfA22gThhrthBR1HsnKVuFwYpDcsA1u1SBKVQ/rmuS/dxZWeQu23rGHAG8JcxzqyUnkBweuTFgedbXa/mljTRm6MI0XJozMMUtOMlKw/90RrBc9j4UBjrmVSZakNz/cERNnWCFFvTLMJRI5oCHaK6M3VTpY=
Date: Tue, 17 Apr 2007 16:37:25 +0200
From: Diego Calleja <diegocg@gmail.com>
To: Tomasz =?UTF-8?B?S8WCb2N6a28=?= <kloczek@rudy.mif.pg.gda.pl>
Cc: Theodore Tso <tytso@mit.edu>, "David R. Litwin" <presently42@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: ZFS with Linux: An Open Plea
Message-Id: <20070417163725.05bd08f1.diegocg@gmail.com>
In-Reply-To: <Pine.BSO.4.63.0704171527150.11088@rudy.mif.pg.gda.pl>
References: <op.tqw1g6n0ftfxs2@localhost.localdomain>
	<20070417131045.GB18373@thunk.org>
	<Pine.BSO.4.63.0704171527150.11088@rudy.mif.pg.gda.pl>
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.10.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Tue, 17 Apr 2007 15:47:32 +0200 (CEST), Tomasz Kłoczko <kloczek@rudy.mif.pg.gda.pl> escribió:

> Realy can't or don't want (?)

Relicensing the whole kernel under the CDDL just to be able to get ZFS is
not going to happen (I bet that rewriting ZFS is easier than relicensing a
large piece of software with thousand of different copyrigth owners ;)

Either Sun relicenses Solaris under a GPL-compatible license (which may
happen, as Sun's CEO has said they may relicense it under the GPL3), or
Linux won't get ZFS except using the FUSE backend. If you miss ZFS, you
always can use solaris. 
