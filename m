Return-Path: <linux-kernel-owner+w=401wt.eu-S1754609AbYC3UeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbYC3UeV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 16:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbYC3UeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 16:34:12 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:36653 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbYC3UeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 16:34:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=uEr/5sPyco0pqNXVjDAeCb7zT4wPs6I1mUyG+xLg5wGk5CqFf5wWUWswXdubbyLvqJWKaOYet3LA+gG9mYdmqUFbdmCIa9A13OSFz1g0qiVUJOQAhI/mDyLG8qFlkhUxN74Lq8OTEt35COidGZw/XdQF0+kA3yG6urEC934oSOI=
Date: Sun, 30 Mar 2008 22:33:21 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Bongani Hlope <bonganilinux@mweb.co.za>
Cc: Douglas Schilling Landgraf <dougsland@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc regression: bttv: oops on radio access (bisected)
Message-ID: <20080330203225.GA8031@joi>
References: <20080330162006.GA6048@joi> <200803302222.20457.bonganilinux@mweb.co.za>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803302222.20457.bonganilinux@mweb.co.za>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 30, 2008 at 10:22:20PM +0200, Bongani Hlope wrote:
> On Sunday 30 March 2008 18:20:49 Marcin Slusarz wrote:
> >
> > ps: note that offending patch introduced build breakage and the fix was
> >     commited 90 revisions later
> 
> Does 2.6.25-rc1 work for you? That's the first broken kernel I've reported for 
> the radio application?
no, it does not work

Marcin

