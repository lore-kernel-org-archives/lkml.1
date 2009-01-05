Return-Path: <linux-kernel-owner+w=401wt.eu-S1759239AbZAEBiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759239AbZAEBiT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 20:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbZAEBiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 20:38:09 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:53465
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbZAEBiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 20:38:09 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Theodore Tso <tytso@mit.edu>
Subject: Re: document ext3 requirements
Date: Sun, 4 Jan 2009 19:38:04 -0600
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; x86_64; ; )
Cc: Pavel Machek <pavel@suse.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
References: <20090103123813.GA1512@ucw.cz> <200901041349.49906.rob@landley.net> <20090104220634.GD22958@mit.edu>
In-Reply-To: <20090104220634.GD22958@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901041938.05134.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 January 2009 16:06:34 Theodore Tso wrote:
> True enough, although the newer SSD's will have this problem addressed
> (although at least initially, they are **far** more costly than the
> el-cheapo 32GB SD cards you can find at the checkout counter at Fry's
> alongside battery-powered shavers and trashy ipod speakers).

I have great faith in the ability of PC hardware to continue to be crap for 
the foreseeable future.

> I will stress again, that most of this doesn't belong in
> Documentation/filesystems/ext3.txt, as most of this is *not*
> ext3-specific.

Yes and no.  Ext3 is enough of a "default" filesystem for Linux that some 
documentation on when _not_ to use sounds like a good idea.

That said, some kind of a "choosing a filesystem" file would be good, perhaps 
under the filesystems directory.  (Then the ext3 doc would just need a brief 
comment and a pointer to the other file.)

Rob
