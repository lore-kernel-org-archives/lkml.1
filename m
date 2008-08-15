Return-Path: <linux-kernel-owner+w=401wt.eu-S1753723AbYHOVoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723AbYHOVoz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 17:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670AbYHOVor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 17:44:47 -0400
Received: from colo.lackof.org ([198.49.126.79]:49296 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752747AbYHOVoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 17:44:46 -0400
Date: Fri, 15 Aug 2008 15:44:34 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: John David Anglin <dave@hiauly1.hia.nrc.ca>
Cc: Adrian Bunk <bunk@kernel.org>, grundler@parisc-linux.org, kyle@mcmartin.ca,
       matthew@wil.cx, linux-parisc@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, bdale@hp.com
Subject: Re: [2.6 patch] binfmt_som.c: add MODULE_LICENSE
Message-ID: <20080815214434.GB5773@colo.lackof.org>
References: <20080811104643.GA3338@cs181140183.pp.htv.fi> <20080811145652.100E74E77@hiauly1.hia.nrc.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080811145652.100E74E77@hiauly1.hia.nrc.ca>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2008 at 10:56:51AM -0400, John David Anglin wrote:
...
> I don't understand why we are talking about HP here.

My bad. I thought HP owned the copy right to the bulk of the code
and Matthew demonstrated they do not.

>  According to
> Matthew, his last commit to this file occured while he worked for
> Genedata.  It is my understanding that copyright normally acrues
> to employers in employment situations.  If Matthew was an employee
> and not an independent contractor at the time, then why are we not
> talking about Genedata, or its subsequent owner?  Subsequent
> employment at HP or their funding of the parisc port shouldn't
> affect the licensing of a file that was previously contributed.

Correct. I thought the work was done by HP employees and that was wrong.

sorry,
grant

> The file appears to be a derived work.  This may also affect its
> copyright status.  The only reason HP should be involved is if the
> file somehow contains material copyrighted by HP.
> 
> The whole licensing issue for the linux program and modules,
> particularly for individual files, appears to be a mess.  The
> COPYING file is vague on the licensing for files.   The recommended
> wording suggested by the FSF isn't used.  I can't see that adding
> MODULE_LICENSE("GPL") lines is going to help much.
> 
> There are several GPL licenses and versions.  The line isn't
> going to mean much to a lawyer.  I really think each file should
> be specific about its licensing in words that can be clearly
> understood.
> 
> Dave
> -- 
> J. David Anglin                                  dave.anglin@nrc-cnrc.gc.ca
> National Research Council of Canada              (613) 990-0752 (FAX: 952-6602)
