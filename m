Return-Path: <linux-kernel-owner+w=401wt.eu-S1753509AbZHIJeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbZHIJeh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 05:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbZHIJeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 05:34:36 -0400
Received: from bar.sig21.net ([80.81.252.164]:53306 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397AbZHIJef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 05:34:35 -0400
Date: Sun, 9 Aug 2009 11:34:30 +0200
From: Johannes Stezenbach <js@sig21.net>
To: ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: ath5k broken after suspend-to-ram
Message-ID: <20090809093430.GA6325@sig21.net>
References: <20090807215155.GA17043@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090807215155.GA17043@sig21.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -3.8 (---)
X-Spam-21-Report: No, score=-3.8 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.644,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 11:51:55PM +0200, Johannes Stezenbach wrote:
> 
> On my old Thinkpad T42p running linux-2.6.31-rc5-246-g90bc1a6,
> after suspend-to-RAM ath5k cannot associate to an AP using WPA
> anymore.  It worked with kernel 2.6.29.1.

FWFI, it also works with 2.6.30.  (I could not initialliy test
with 2.6.30 because suspend/resume is broken in that kernel,
but it can be fixed up with a workaround patch.)


Johannes
