Return-Path: <linux-kernel-owner+w=401wt.eu-S1757873AbXH2SvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873AbXH2SvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 14:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753661AbXH2Su5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 14:50:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753517AbXH2Su4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 14:50:56 -0400
Message-ID: <46D5BF7D.10706@redhat.com>
Date: Wed, 29 Aug 2007 14:48:29 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Oliver Neukum <oneukum@suse.de>, "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>, torvalds@linux-foundation.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chuck Wolber <chuckw@quantumlinux.com>, stable@kernel.org,
       alan@lxorguk.ukuu.org.uk,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [stable] [patch 25/28] USB: cdc-acm: fix sysfs attribute	registration
 bug
References: <20070824154906.GA19239@kroah.com> <Pine.LNX.4.44L0.0708241349240.3862-100000@iolanthe.rowland.org> <20070824180423.GA5458@suse.de>
In-Reply-To: <20070824180423.GA5458@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2007 02:04 PM, Greg KH wrote:
> 
> I'm starting to really appreciate Linus's hate for patch-fuzz :)
> 

If you're using quilt, add this to .quiltrc:

QUILT_PATCH_OPTS="--fuzz=1"

