Return-Path: <linux-kernel-owner+w=401wt.eu-S1754293AbYCQRbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbYCQRbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 13:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbYCQRbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 13:31:12 -0400
Received: from gv-out-0910.google.com ([216.239.58.185]:6989 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbYCQRbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 13:31:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=xbwCkUSnCZPlmzDBQAM40o44JTXJXvvejiPqCb4Kmc/jo0Y7kETSiW+nM9ehdGX8DwXSvNpjsjiaWMw+N+zVOuGBbM1QtJdH3EGtiJpV8IISFN3Xc81cyjnYs7k3P6+xFrjw6vuF1oGQs1xp9Hhv4tdiElS0sdK2I1QFMnY9N3w=
Message-ID: <bb6f8c2e0803171031o789cd2d2jd3649f1c4db0fbd2@mail.gmail.com>
Date: Mon, 17 Mar 2008 10:31:08 -0700
From: "john chen" <jchen1996@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: display class questions in the kernel?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Linux community.

I was just wondering if anyone is actively maintaining
drivers/video/display/display-sysfs.c, or the display class.  I am
looking at the version in 2.6.24.3 and I noticed that it hasn't been
updated since 2.6.22.  Just curious if anyone is maintaining this
actively?

I also didn't find any code in the drivers/video sub-directory that is
actually using the "display class".  I found some examples and
possible updates from James Simmons on the web, but it seems like
nothing has been rolled into the main branch.  I also found some bug
fixes on the web (dated early '07), but again, nothing officially
rolled into 2.6.24.3.

I'm asking because I would like to do some work (and possibly expand)
the display class, just wanted get some background information before
I get started.

Just curious.  Thanks for all your support.  Please CC
jchen1996@gmail.com for the responses!

thanks.
john
