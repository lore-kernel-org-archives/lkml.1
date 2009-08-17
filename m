Return-Path: <linux-kernel-owner+w=401wt.eu-S1753829AbZHQOKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbZHQOKl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 10:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbZHQOKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 10:10:40 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:53504 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbZHQOKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 10:10:39 -0400
Date: Mon, 17 Aug 2009 08:10:38 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Mark Lord <liml@rtr.ca>,
       Chris Worley <worleys@gmail.com>, Bryan Donlan <bdonlan@gmail.com>,
       david@lang.hm, Greg Freemyer <greg.freemyer@gmail.com>,
       Markus Trippelsdorf <markus@trippelsdorf.de>,
       Matthew Wilcox <willy@linux.intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Nitin Gupta <ngupta@vflare.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: Discard support (was Re: [PATCH] swap: send callback when swap
	slot is freed)
Message-ID: <20090817141038.GB11966@parisc-linux.org>
References: <20090814234539.GE27148@parisc-linux.org> <f3177b9e0908141719s658dc79eye92ab46558a97260@mail.gmail.com> <1250341176.4159.2.camel@mulgrave.site> <4A86B69C.7090001@rtr.ca> <1250344518.4159.4.camel@mulgrave.site> <20090816150530.2bae6d1f@lxorguk.ukuu.org.uk> <20090816083434.2ce69859@infradead.org> <1250437927.3856.119.camel@mulgrave.site> <20090816165943.GA26983@infradead.org> <1250517372.3844.3.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250517372.3844.3.camel@mulgrave.site>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 17, 2009 at 08:56:12AM -0500, James Bottomley wrote:
> The testing was initially done to see if the initial maximal discard
> proposal from LSF09 was a viable approach (which it wasn't given the
> time taken to UNMAP).

It would be nice if that feedback could be made public instead of it
leaking out in dribs and drabs like this.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
