Return-Path: <linux-kernel-owner+w=401wt.eu-S1754935AbXJ3VxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935AbXJ3VxU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 17:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbXJ3VxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 17:53:10 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:55172 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbXJ3VxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 17:53:09 -0400
Date: Tue, 30 Oct 2007 22:53:05 +0100
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       linux-kernel@vger.kernel.org,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: Huawei E220 and usb storage
Message-ID: <20071030215305.GB14449@gamma.logic.tuwien.ac.at>
References: <20071030190945.GC32153@gamma.logic.tuwien.ac.at> <20071030211729.6a80a93a.Kristoffer.ericson@gmail.com> <20071030204720.GI8479@gamma.logic.tuwien.ac.at> <47279EF7.3040406@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47279EF7.3040406@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Di, 30 Okt 2007, Chuck Ebbert wrote:
> Did you see commit d853d872c14b9adc4adad29e56cd378b291f86e0 ?

2.6.23 + this commit exhibits the same problems I describe before ...
permanent disconnect/connect problems. Not even using the mentioned
program does switch the usb modem into the right mode.

So this patch seems to be bogus...

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
HEVER (n.)
The panic caused by half-hearing Tannoy in an airport.
			--- Douglas Adams, The Meaning of Liff
