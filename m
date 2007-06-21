Return-Path: <linux-kernel-owner+w=401wt.eu-S1754915AbXFUXtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915AbXFUXtp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 19:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254AbXFUXtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 19:49:36 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35837 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbXFUXtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 19:49:35 -0400
Subject: Re: Please release a stable kernel Linux 3.0
From: Arjan van de Ven <arjan@infradead.org>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Zolt?n HUBERT <zoltan.hubert@zzaero.com>, linux-kernel@vger.kernel.org
In-Reply-To: <467B04EB.2010105@redhat.com>
References: <200706212349.54983.zoltan.hubert@zzaero.com>
	 <9a8748490706211529yca0588dgd1f7e0b86f7e4a62@mail.gmail.com>
	 <467AFCEC.2070203@redhat.com> <20070621230126.GF10008@csclub.uwaterloo.ca>
	 <467B04EB.2010105@redhat.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Thu, 21 Jun 2007 16:45:40 -0700
Message-Id: <1182469541.2704.13.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-21 at 19:08 -0400, Chuck Ebbert wrote:
> On 06/21/2007 07:01 PM, Lennart Sorensen wrote:
> > On Thu, Jun 21, 2007 at 06:34:20PM -0400, Chuck Ebbert wrote:
> >> Even the good ones that get lots of fixes aren't all that good. The
> >> biggest problem ATM is that suspend is badly broken and keeps getting
> >> worse...
> > 
> > I wasn't under the impression suspend had really ever worked.  Such a
> > messy problem to solve.
> > 
> 
> It never worked reliably for everyone, but with each new release it
> seems to get worse.

the thing is just fundamentally not designed right. Declaring it stable
ain't gonna fix that. Having someone do a right design (which will
obviously will go through some breakage period, even if it's an
evolution of the current design) is a required step of getting s/r more
reliable... but the current one doesn't get stable just by declaring it
so.


