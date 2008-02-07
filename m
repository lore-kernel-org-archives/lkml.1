Return-Path: <linux-kernel-owner+w=401wt.eu-S1761243AbYBGM4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761243AbYBGM4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 07:56:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbYBGM42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 07:56:28 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52588 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbYBGM41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 07:56:27 -0500
Date: Thu, 7 Feb 2008 07:56:22 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Paalanen <pq@iki.fi>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 4/4] x86 mmiotrace: move files into arch/x86/mm/
Message-ID: <20080207125622.GA7111@infradead.org>
References: <1201660453.8837.13.camel@brick> <20080130200827.322c4f7d@daedalus.pq.iki.fi> <20080131150746.GB11996@elte.hu> <20080131180253.6c007852@daedalus.pq.iki.fi> <20080131081507.5edcde10@laptopd505.fenrus.org> <20080203085522.2b63e15b@daedalus.pq.iki.fi> <20080203070321.GA8293@elte.hu> <20080205222807.7b35ef2b@daedalus.pq.iki.fi> <20080205223958.2cab8ce3@daedalus.pq.iki.fi> <20080207125327.GB27234@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080207125327.GB27234@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2008 at 01:53:27PM +0100, Ingo Molnar wrote:
> 
> Pekka,
> 
> i've picked up your latest cleanups, but a fundamental worry still 
> remains: all the ugly 'custom pagefault handlers' stuff. Lets just have 
> one clean direct callback to mmiotrace, ok?

Yes, please.  And any chance we you could resend the current version of
the patch to lkml?  I've lost a little track of how it looks currently.

