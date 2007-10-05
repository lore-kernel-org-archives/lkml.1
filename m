Return-Path: <linux-kernel-owner+w=401wt.eu-S1763491AbXJEQG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763491AbXJEQG6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 12:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756770AbXJEQGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 12:06:48 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:60955 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756126AbXJEQGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 12:06:47 -0400
Date: Fri, 5 Oct 2007 18:07:50 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Howells <dhowells@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, viro@ftp.linux.org.uk,
       torvalds@osdl.org, akpm@osdl.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 01/32] Add an ERR_CAST() macro to complement ERR_PTR and co. [try #2]
Message-ID: <20071005160750.GA31413@uranus.ravnborg.org>
References: <20071005144605.GA3072@infradead.org> <20071004155602.2814.47731.stgit@warthog.procyon.org.uk> <20071004155607.2814.74947.stgit@warthog.procyon.org.uk> <17643.1191599256@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17643.1191599256@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2007 at 04:47:36PM +0100, David Howells wrote:
> Christoph Hellwig <hch@infradead.org> wrote:
> 
> > I don't like this one very much, I'd rather take the variant Linus
> > outline in his last post on that topic..
> 
> I'd rather not take that variant.

One like one variant, another like another variant.
Both fails to say why.

So you left everyone wondering.....

	Sam
