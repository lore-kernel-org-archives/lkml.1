Return-Path: <linux-kernel-owner+w=401wt.eu-S1757365AbZALUa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365AbZALUa0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 15:30:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbZALUaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 15:30:15 -0500
Received: from verein.lst.de ([213.95.11.210]:35496 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842AbZALUaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 15:30:14 -0500
Date: Mon, 12 Jan 2009 21:30:07 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org
Subject: Re: oops in __bounce_end_io_read under kvm
Message-ID: <20090112203007.GB24633@lst.de>
References: <20081226173606.GA14933@lst.de> <20081228181057.GV32491@kernel.dk> <20081228181948.GA23568@lst.de> <20081228182459.GX32491@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081228182459.GX32491@kernel.dk>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FYI this is so far 100% reproducible when running xfsqa twice without
rebooting the virtual machine.
