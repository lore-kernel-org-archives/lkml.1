Return-Path: <linux-kernel-owner+w=401wt.eu-S1757261AbZAXDXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261AbZAXDXv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 22:23:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753987AbZAXDXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 22:23:44 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46787 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959AbZAXDXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 22:23:43 -0500
Date: Fri, 23 Jan 2009 22:23:42 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Christoph Hellwig <hch@infradead.org>,
       Lars Noschinski <lkml@ml.noschinski.de>, linux-kernel@vger.kernel.org
Subject: Re: XFS error & call trace
Message-ID: <20090124032342.GA14080@infradead.org>
References: <20090121222703.GA5522@aprove.informatik.rwth-aachen.de> <20090121231435.GA6810@infradead.org> <20090123055109.GA25601@x61>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090123055109.GA25601@x61>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2009 at 06:51:09AM +0100, Tino Keitel wrote:
> does this commit also fix http://lkml.org/lkml/2009/1/7/324 ?

Yes, it should.

