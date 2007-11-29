Return-Path: <linux-kernel-owner+w=401wt.eu-S1763445AbXK2RwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763445AbXK2RwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 12:52:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761261AbXK2RwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 12:52:08 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37933 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761132AbXK2RwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 12:52:07 -0500
Date: Thu, 29 Nov 2007 17:51:55 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Greg KH <greg@kroah.com>, Jan Engelhardt <jengelh@computergmbh.de>,
       Jon Masters <jonathan@jonmasters.org>, Valdis.Kletnieks@vt.edu,
       Christoph Hellwig <hch@infradead.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       "Tvrtko A. Ursulin" <tvrtko.ursulin@sophos.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Out of tree module using LSM
Message-ID: <20071129175155.GY8181@ftp.linux.org.uk>
References: <25290.1196273705@turing-police.cc.vt.edu> <20071128183040.GW8181@ftp.linux.org.uk> <20071129003840.GA22530@kroah.com> <Pine.LNX.4.64.0711290152470.22052@fbirervta.pbzchgretzou.qr> <20071129010753.GA19106@kroah.com> <1196354172.6473.52.camel@perihelion> <20071129164746.GB9664@kroah.com> <Pine.LNX.4.64.0711291752550.13075@fbirervta.pbzchgretzou.qr> <20071129170326.GA10024@kroah.com> <2c0942db0711290935l56d28b70v2b35dfb1663e4d2b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c0942db0711290935l56d28b70v2b35dfb1663e4d2b@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 09:35:56AM -0800, Ray Lee wrote:

> Perhaps if you looked at this outside of a file-server scenario, the
> problem would be clearer? Anti-malware companies want to check
> anything written to disk on a system, either at write time or blocking
> the open/mmap. That means proactively protecting email programs with
> known vulnerabilities that have yet to be patched, web browsers
> writing and reading their caches, an Apache instance running WebDAV,
> the list goes on. And these are on desktop systems, with no attached
> file/network server.

... and anything promising that is a grade-A snake oil.
