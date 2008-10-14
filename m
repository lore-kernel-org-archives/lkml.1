Return-Path: <linux-kernel-owner+w=401wt.eu-S1753947AbYJNVbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbYJNVbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 17:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbYJNVbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 17:31:25 -0400
Received: from genesysrack.ru ([195.178.208.66]:54007 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbYJNVbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 17:31:24 -0400
Date: Wed, 15 Oct 2008 01:31:23 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andreas Dilger <adilger@sun.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Distributed storage release.
Message-ID: <20081014213123.GA32387@2ka.mipt.ru>
References: <20081006160034.GA611@2ka.mipt.ru> <20081012192419.fd8394c9.akpm@linux-foundation.org> <20081013133850.GA13565@2ka.mipt.ru> <20081014155143.GM2009@webber.adilger.int> <20081014161256.GA22286@2ka.mipt.ru> <20081014203529.GW2009@webber.adilger.int> <20081014210827.GA31312@2ka.mipt.ru> <20081014212332.GI15064@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081014212332.GI15064@parisc-linux.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew.

On Tue, Oct 14, 2008 at 03:23:32PM -0600, Matthew Wilcox (matthew@wil.cx) wrote:
> > Standards are great, but killing a child just because he or she is
> > left-hander, is a bit crazy, don't you think? So it would be quite
> > interesting to hear that (at least one) showstopper for inclusion
> > is a number of spaces :)
> 
> You're blowing this way out of proportion.  Andrew said he'd be happy to
> do a better review of it if you documented it better, but until then all
> he could find time to do was a stylistic review.

Are you absolutely sure we are talking here not about killed christian kids?

Didn't you accidentally miss that part, where I added documentation and
released new version where 10% of the patch is code documentation in
several hours :)

Essentially I resolved all comments Andrew made except checkpatch output
and library functions which I asked if they are really needed. Even
checkpatch output was cleaned (I removed long lines and added comments).

-- 
	Evgeniy Polyakov
