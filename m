Return-Path: <linux-kernel-owner+w=401wt.eu-S1030683AbXDPOz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030683AbXDPOz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 10:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030736AbXDPOz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 10:55:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47792 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030683AbXDPOz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 10:55:57 -0400
Date: Mon, 16 Apr 2007 15:55:27 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Tomasz K?oczko <kloczek@rudy.mif.pg.gda.pl>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Mike Snitzer <snitzer@gmail.com>, Neil Brown <neilb@suse.de>,
       "David R. Litwin" <presently42@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: ZFS with Linux: An Open Plea
Message-ID: <20070416145527.GA26863@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Tomasz K?oczko <kloczek@rudy.mif.pg.gda.pl>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Jan Engelhardt <jengelh@linux01.gwdg.de>,
	Mike Snitzer <snitzer@gmail.com>, Neil Brown <neilb@suse.de>,
	"David R. Litwin" <presently42@gmail.com>,
	linux-kernel@vger.kernel.org
References: <op.tqqwdfzcftfxs2@localhost.localdomain> <17952.5537.364603.419364@notabene.brown> <170fa0d20704140704l29d9db76q59195a3d9cad868a@mail.gmail.com> <Pine.LNX.4.61.0704142251380.15892@yvahk01.tjqt.qr> <Pine.BSO.4.63.0704161120070.11088@rudy.mif.pg.gda.pl> <46238204.9060907@s5r6.in-berlin.de> <Pine.BSO.4.63.0704161606280.11088@rudy.mif.pg.gda.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.BSO.4.63.0704161606280.11088@rudy.mif.pg.gda.pl>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2007 at 04:20:41PM +0200, Tomasz K?oczko wrote:
> ZFS on Solaris provides for many workloads better speed than any Linux 
> technology on the same hardware but ZFS ond FUSE in current form provides 
> lower speed than now avalaible Linux technologies.

Numbers, please.  So far in all interesting benchmarks it actually
was slower.  But when they're faster than XFS somewhere I'd defintly
be interesting in looking at why this is true and if possible and
important enough fix it.

