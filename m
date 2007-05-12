Return-Path: <linux-kernel-owner+w=401wt.eu-S1758015AbXELKKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015AbXELKKb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 06:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755564AbXELKKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 06:10:25 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:23513 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556AbXELKKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 06:10:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=W050WFG8QWYVgMYMuK+8oMzgfHn8wP/tSHJ8wh8SrT22zlPxJWp5UI/NBbLY0jlzv+B61z7wqnqkhDg9exo6qKjRz8MWjE7SYy/1uOm1IKsz5oTcODDJfy/sFedDXjFkfBYTKnmzkJXpdCqVQODTyoGz6XVA2cEK7+/f05juJdE=
Date: Sat, 12 May 2007 14:09:49 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Christoph Hellwig <hch@infradead.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@ucw.cz>
Subject: Re: [PATCH] UDF: check for allocated memory for inode data
Message-ID: <20070512100949.GC8337@cvg>
References: <20070510140000.GA12399@cvg> <20070510154640.c0299a52.akpm@linux-foundation.org> <20070511072939.GA25727@infradead.org> <20070511090127.GD9444@cvg> <20070511103956.GA30896@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070511103956.GA30896@infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph,

you know I've got a question (may be it's stupid) - what a
sense to discard UDF_I_* macroses? I mean as I see they
don't slow down execution of the code...

		Cyrill

