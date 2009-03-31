Return-Path: <linux-kernel-owner+w=401wt.eu-S1758588AbZCaWhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588AbZCaWhq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 18:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755955AbZCaWhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 18:37:37 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:44446 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890AbZCaWhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 18:37:36 -0400
X-Greylist: delayed 417 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Mar 2009 18:37:36 EDT
Subject: Re: Linux 2.6.29
From: Bojan Smojver <bojan@rexursive.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <49D29077.80502@goop.org>
References: <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain>
	 <20090326171148.9bf8f1ec.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain>
	 <20090326174704.cd36bf7b.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain>
	 <20090327032301.GN6239@mit.edu> <20090327034705.GA16888@srcf.ucam.org>
	 <20090327051338.GP6239@mit.edu> <20090327055750.GA18065@srcf.ucam.org>
	 <20090327062114.GA18290@srcf.ucam.org> <20090327112438.GQ6239@mit.edu>
	 <49CD4109.2070505@goop.org> <loom.20090328T073850-695@post.gmane.org>
	 <loom.20090328T084304-506@post.gmane.org>
	 <loom.20090328T214417-565@post.gmane.org>  <49D29077.80502@goop.org>
Content-Type: text/plain
Date: Wed, 01 Apr 2009 09:30:36 +1100
Message-Id: <1238538636.26693.11.camel@shrek.rexursive.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-31 at 14:51 -0700, Jeremy Fitzhardinge wrote:
> I was thinking something like "munge_important_stuff | fsync > output"
> - ie, cat which fsyncs on close.

Yeah, after I wrote my initial comment, I noticed you were saying
essentially the same thing in your original post. I know, I should
_read_ before posting. Sorry :-(

> In fact, its vaguely surprising that GNU  cat doesn't have this
> already.

I have no idea why we don't have that either. FreeBSD code seems really
straightforward.

-- 
Bojan

