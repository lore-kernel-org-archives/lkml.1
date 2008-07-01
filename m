Return-Path: <linux-kernel-owner+w=401wt.eu-S1760608AbYGAPSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760608AbYGAPSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 11:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758866AbYGAPSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 11:18:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38386 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758774AbYGAPST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 11:18:19 -0400
Date: Tue, 1 Jul 2008 11:17:50 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Elias Oltmanns <eo@nebensachen.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Dave Chinner <david@fromorbit.com>,
       xfs-masters@oss.sgi.com, Jeremy Fitzhardinge <jeremy@goop.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, David Chinner <dgc@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [xfs-masters] Re: freeze vs freezer
Message-ID: <20080701151750.GA15018@infradead.org>
References: <4744FD87.7010301@goop.org> <200807010038.43362.rjw@sisk.pl> <20080701063835.GQ29319@disturbed> <200807011635.44696.rjw@sisk.pl> <87tzf9hcg6.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tzf9hcg6.fsf@denkblock.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 05:05:29PM +0200, Elias Oltmanns wrote:
> There is some work in progress [1]. If you think this will help you to
> address this issue on the fs level, where I think it should be done, you
> may even be able to request some changes to fit your needs before it
> gets merged into mainline.

That is just a direct user interface to this functionality.  The
functionality has been around for a long time.

