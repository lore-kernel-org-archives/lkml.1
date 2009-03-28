Return-Path: <linux-kernel-owner+w=401wt.eu-S1761659AbZC1W2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761659AbZC1W2S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 18:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755338AbZC1W2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 18:28:01 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:59272
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548AbZC1W2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 18:28:01 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Subject: Re: Squashfs 4.0 tools
Date: Sat, 28 Mar 2009 17:27:51 -0500
User-Agent: KMail/1.9.10
Cc: Stephen Hemminger <shemminger@vyatta.com>, linux-kernel@vger.kernel.org,
       squashfs-devel@lists.sourceforge.net
References: <20090323180808.2c2ef1a7@nehalam> <49C847C6.4030904@lougher.demon.co.uk>
In-Reply-To: <49C847C6.4030904@lougher.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903281727.52929.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 March 2009 21:39:02 Phillip Lougher wrote:
> Stephen Hemminger wrote:
> > It is great that squashfs is finally in mainline kernel. But the
> > squashfs tools are tightly bound to the version of the squashfs
> > filesystem. The latest tools in Debian (and the download page) are
> > limited to version 3.4 but the upstream kernel version is 4.0!
> >
> > Do we have a cart with no horse here?
>
> The horse is currently in training, or to put it more mundanely, the
> squashfs 4.0 tools are currently in Squashfs CVS :-)
>
> I have been working on the 4.0 squashfs tools for the last couple of
> months making them (mksquashfs and unsquashfs) ready for a supported
> release.  Now that Linux 2.6.29 has been released (3 hours ago), I
> need to make this release ASAP, which as everything is almost finished,
> should be sometime this week.

Any updated ETA on this?

Rob

P.S I notice a squashfs-devel mailing list cc'd here, but there's no link to 
it from the squashfs.org page.  Buried in the middle of a lot of text is a 
link to the sourceforge squashfs project page, which has a link to "forums" 
which are not the same as mailing lists.

Since I knew it's called "squashfs-devel" I could google for that and find 
http://sourceforge.net/mailarchive/forum.php?forum_name=squashfs-devel

But it might be nice to at least _hint_ about its existence on the web page.  
The main page's "contact" section is your personal email and nothing else...
