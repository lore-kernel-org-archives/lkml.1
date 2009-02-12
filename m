Return-Path: <linux-kernel-owner+w=401wt.eu-S1761248AbZBLWRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761248AbZBLWRZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 17:17:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758456AbZBLWRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 17:17:16 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53058 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079AbZBLWRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 17:17:15 -0500
Subject: Re: git-send-email
From: Peter Zijlstra <peterz@infradead.org>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Ingo Oeser <ioe-lkml@rameria.de>, Junio C Hamano <gitster@pobox.com>,
       L-K <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20090212192104.GD15809@csclub.uwaterloo.ca>
References: <1234451714.10603.22.camel@laptop>
	 <200902121825.35021.ioe-lkml@rameria.de>
	 <20090212192104.GD15809@csclub.uwaterloo.ca>
Content-Type: text/plain
Date: Thu, 12 Feb 2009 23:17:05 +0100
Message-Id: <1234477025.10603.38.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-12 at 14:21 -0500, Lennart Sorensen wrote:
> On Thu, Feb 12, 2009 at 06:25:34PM +0100, Ingo Oeser wrote:
> > No, they are great, if you like to skip over a topic, you are not
> > interested in at all!
> > 
> > If you don't like it, just switch off thread in your mailer and
> > don't force this on everybody else!
> 
> Actually if (as apparently many people seem to manage to do) you have a
> single starting email, with all the patches as replies to that first
> email, it looks a lot better, and is much easier to follow.
> 
> Seperate threads would be bad.
> 
> foobar patch 0 (usually a summary/overview)
> +-foobar patch 1
> +-foobar patch 2
> +-foobar patch 3
> +-foobar patch 4
> +-foobar patch 5
> 
> is much nicer than
> 
> foobar patch 0
> +-foobar patch 1
>   +-foobar patch 2
>     +-foobar patch 3
>       +-foobar patch 4
>         +-foobar patch 5
> 
> which seems to be what git does itself.

Which happens to be exactly what my suggestion would accomplish.

--[no-]chain-reply-to
        
        If this is set, each email will be sent as a reply to the
        previous email sent. If disabled with "--no-chain-reply-to", all
        emails after the first will be sent as replies to the first
        email sent. When using this, it is recommended that the first
        file given be an overview of the entire patch series. Default is
        the value of the sendemail.chainreplyto configuration value; if
        that is unspecified, default to --chain-reply-to.
        
        


