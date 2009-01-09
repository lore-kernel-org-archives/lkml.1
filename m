Return-Path: <linux-kernel-owner+w=401wt.eu-S1753230AbZAICas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbZAICas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 21:30:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbZAICaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 21:30:21 -0500
Received: from rv-out-0506.google.com ([209.85.198.228]:22183 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202AbZAICaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 21:30:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=fOVblfAVmnwaE+DoQZhdaWSYBtLoHJDBj0rSHn5WLdx8iszMeQH97M+ljGHdb0+ugh
         j2voLowXS30ObtecWjs+qKVGn6OL7WGySh4vIcs+Q3wHbZBGAk62mj0jSmwXLOKIW6Cv
         8bVsBGv/sn+1+p+5mVM2wBgCYG+gjy5Ps4IVI=
Subject: Re: [GIT PULL] Squashfs pull request for 2.6.29
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20090108175338.2abbee16.akpm@linux-foundation.org>
References: <E1LKy3v-0003KO-Nx@dylan.lougher.demon.co.uk>
	 <20090108165029.GA10951@infradead.org>
	 <20090108175338.2abbee16.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 08 Jan 2009 18:30:15 -0800
Message-Id: <1231468215.5715.42.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-08 at 17:53 -0800, Andrew Morton wrote:
> On Thu, 8 Jan 2009 11:50:29 -0500 Christoph Hellwig <hch@infradead.org> wrote:
> 
> > On Thu, Jan 08, 2009 at 04:48:51PM +0000, Phillip Lougher wrote:
> > > Please consider pulling my linux-next branch
> > > 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-linus.git
> > > 
> > > The patches have been posted to LKML and linux-fsdevel over the last
> > > couple of months and have been reviewed and changed as requested.
> > > Diffstat below.
> > > 
> > > Squashfs is a compressed read-only filesystem. It compresses metadata
> > > and data, and uses up to 1 MiB block sizes for greater compression.
> > 
> > That seems pretty fast for something only posted this week and not
> > even in -next.
> 
> I discussed this with Phillip a bit, and it looks like we'll go for a
> 2.6.21 merge.  This gives a couple of months for testing and review in
> linux-next.

akpm time machine?  I'll assume that means squashfs is headed for a
2.6.30 merge?  Or .29?

Harvey

