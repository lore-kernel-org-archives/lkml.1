Return-Path: <linux-kernel-owner+w=401wt.eu-S938954AbZDJRmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938954AbZDJRmR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 13:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbZDJRl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 13:41:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56694 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbZDJRl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 13:41:57 -0400
Date: Fri, 10 Apr 2009 13:41:55 -0400
From: Christoph Hellwig <hch@infradead.org>
To: hooanon05@yahoo.co.jp
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       greg@kroah.com, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC Aufs2 #5 28/29] export lookup functions
Message-ID: <20090410174154.GA21997@infradead.org>
References: <1239346963-30953-1-git-send-email-hooanon05@yahoo.co.jp> <1239346963-30953-29-git-send-email-hooanon05@yahoo.co.jp> <20090410162849.GA28377@infradead.org> <7612.1239382035@jrobl> <20090410165401.GA20673@infradead.org> <8041.1239382994@jrobl> <20090410170506.GA29152@infradead.org> <8416.1239384393@jrobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8416.1239384393@jrobl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 11, 2009 at 02:26:33AM +0900, hooanon05@yahoo.co.jp wrote:
> VFS-level union is promising. Actually I am going to try that after aufs
> in the future. I didn't know that people re-started working on union
> mount. It is interesting.

Jan and Val have been working on it again, and Al has started reviewing
it.

> I have been asked to include aufs into mainline from several people
> several times. As long as you have strong NACK for aufs and reject all
> union-type filesystems, I have to give up unwillingly and will answer
> them "Aufs was rejected. Let's give it up."

Yes, that's the case.

