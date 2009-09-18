Return-Path: <linux-kernel-owner+w=401wt.eu-S1757532AbZIRRxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532AbZIRRxv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 13:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757384AbZIRRxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 13:53:51 -0400
Received: from fifo99.com ([67.223.236.141]:36254 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757370AbZIRRxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 13:53:50 -0400
Subject: Re: [PATCH] Add uboot commandline argument passing support to
 m68knommu (Try #2)
From: Daniel Walker <dwalker@fifo99.com>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: linux-kernel@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>,
       uclinux-dev@uclinux.org
In-Reply-To: <20090918174936.GJ23702@csclub.uwaterloo.ca>
References: <20090918162736.GY23700@csclub.uwaterloo.ca>
	 <1253291944.7060.42.camel@desktop>
	 <20090918174936.GJ23702@csclub.uwaterloo.ca>
Content-Type: text/plain
Date: Fri, 18 Sep 2009 10:54:01 -0700
Message-Id: <1253296441.7060.49.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-18 at 13:49 -0400, Lennart Sorensen wrote:
> On Fri, Sep 18, 2009 at 09:39:04AM -0700, Daniel Walker wrote:
> > You have a couple of various checkpatch errors in this patch. We use
> > scripts/checkpatch.pl to check for code style issues. Could you run that
> > on your patch and fix any errors it finds? A couple are whitespace
> > related and you can use scripts/cleanpatch or scripts/cleanfile to
> > remove whitespace (so I hear. I've never run those scripts personally)
> 
> Oh dear.  I guess the original patch was a bit messy then.  OK here we
> go again with a checkpatch approved patch.

Much better, thanks for doing that..

Daniel

