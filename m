Return-Path: <linux-kernel-owner+w=401wt.eu-S1754120AbZLAMb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbZLAMb2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 07:31:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbZLAMb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 07:31:28 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:37571 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082AbZLAMb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 07:31:27 -0500
Date: Tue, 1 Dec 2009 07:31:30 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Matt Turner <mattst88@gmail.com>
Cc: Michael Cree <mcree@orcon.net.nz>, Richard Henderson <rth@twiddle.net>,
       linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
       ink@jurassic.park.msu.ru, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] Alpha: Rearrange thread info flags fixing two
	regressions
Message-ID: <20091201123130.GA23323@infradead.org>
References: <4AE8D005.1030302@twiddle.net> <1256956383-2652-1-git-send-email-mcree@orcon.net.nz> <b4198de60911302006u43f52bd5xe198615971352696@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4198de60911302006u43f52bd5xe198615971352696@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 11:06:52PM -0500, Matt Turner wrote:
> Applied to alpha-2.6.git. Thanks!

Can you push this to Linus ASAP so that 2.6.33 will work nicely out of
the box on alpha?

