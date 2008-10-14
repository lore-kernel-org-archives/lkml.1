Return-Path: <linux-kernel-owner+w=401wt.eu-S1756090AbYJNG6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbYJNG6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 02:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbYJNG6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 02:58:06 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44629 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbYJNG6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 02:58:05 -0400
Subject: Re: [PROBLEM] hard-lock with kmemtrace, relayfs, and splice
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Tom Zanussi <zanussi@comcast.net>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org
In-Reply-To: <1223963208.10883.55.camel@charm-linux>
References: <20080923212914.GB5237@localhost>
	 <1223386477.28348.42.camel@penberg-laptop>
	 <1223623191.8959.26.camel@penberg-laptop>
	 <1223628687.8959.37.camel@penberg-laptop>
	 <1223629803.8959.40.camel@penberg-laptop>
	 <1223631723.8959.46.camel@penberg-laptop>
	 <1223701131.7489.25.camel@charm-linux>
	 <1223881068.31587.1.camel@penberg-laptop>
	 <1223957031.10883.7.camel@charm-linux>  <48F42A93.1040004@cs.helsinki.fi>
	 <1223963208.10883.55.camel@charm-linux>
Date: Tue, 14 Oct 2008 09:58:10 +0300
Message-Id: <1223967490.18017.0.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-14 at 00:46 -0500, Tom Zanussi wrote:
> > Tested-by: Pekka Enberg <penberg@cs.helsinki.fi>
> > 
> > to your patch if you want. Are you going to send it to Andrew or do you 
> > want me to pick it up with rest of the kmemtrace patches?
> 
> If you pick it up that would be fine with me.  Here's my sob:
> 
> Signed-off-by: Tom Zanussi <tzanussi@gmail.com>

Applied, thanks!

http://git.kernel.org/?p=linux/kernel/git/penberg/slab-2.6.git;a=commitdiff;h=51b19be3535c8fbcce6b6f838d89b9a6a4cc5b92

