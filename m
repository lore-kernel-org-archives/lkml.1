Return-Path: <linux-kernel-owner+w=401wt.eu-S1753179AbZGBKr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbZGBKr3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 06:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752375AbZGBKrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 06:47:21 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:43394 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054AbZGBKrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 06:47:20 -0400
Date: Thu, 2 Jul 2009 11:46:49 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       Etienne Basset <etienne.basset@numericable.fr>,
       David Miller <davem@davemloft.net>, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       linux-mips@linux-mips.org, linux-ide@vger.kernel.org
Subject: Re: [Bug #13663] suspend to ram regression (IDE related)
Message-ID: <20090702104649.GC14804@linux-mips.org>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera> <1246459661.9660.40.camel@falcon> <200907011821.26091.bzolnier@gmail.com> <200907011829.16850.bzolnier@gmail.com> <1246499203.9660.52.camel@falcon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246499203.9660.52.camel@falcon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 02, 2009 at 09:46:43AM +0800, Wu Zhangjin wrote:

> Sorry, I can not apply this patch directly, which original version did
> you use? I used the one in the master branch of linux-mips development
> git repository.

The master branch of linux-mips.org has no IDE changes over Linus' tree.

  Ralf
