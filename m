Return-Path: <linux-kernel-owner+w=401wt.eu-S1756803AbZGHNtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbZGHNtj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 09:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755911AbZGHNtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 09:49:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33094 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835AbZGHNtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 09:49:32 -0400
Date: Wed, 8 Jul 2009 09:49:30 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
       linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Subject: Re: [rfc][patch 4/4] fs: tmpfs, ext2 use new truncate
Message-ID: <20090708134930.GB26701@infradead.org>
References: <20090707144423.GC2714@wotan.suse.de> <20090707144918.GF2714@wotan.suse.de> <20090707163829.GB14947@infradead.org> <20090708065327.GM2714@wotan.suse.de> <20090708111420.GB20924@duck.suse.cz> <20090708122250.GP2714@wotan.suse.de> <20090708123244.GA22722@infradead.org> <20090708123904.GR2714@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090708123904.GR2714@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 08, 2009 at 02:39:04PM +0200, Nick Piggin wrote:
> Here is patch 4/4 after your parts folded in and other changes
> I said in last mail. (yes I do agree to split it up, but I'll
> just wait until we all agree on basics and then resend a new
> patchset).

Sure, that's fine.

