Return-Path: <linux-kernel-owner+w=401wt.eu-S1754767AbYKGTMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbYKGTMT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 14:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751119AbYKGTMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 14:12:09 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:51568
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbYKGTMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 14:12:08 -0500
From: Rob Landley <rob@landley.net>
To: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [RFC] Documentation tree sub-directories reorg.
Date: Fri, 7 Nov 2008 13:13:49 -0600
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
       corbet@lwn.net, mtk.manpages@gmail.com, alan@lxorguk.ukuu.org.uk
References: <4910D1BC.9060100@xenotime.net>
In-Reply-To: <4910D1BC.9060100@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811071313.50384.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 November 2008 16:50:36 Randy Dunlap wrote:
> Hi,
>
> I would like to use a few more sub-directories in the Documentation/ tree
> to try to help clean it up some.  E.g., move some drivers/block/ doc files
> to Documentation/blockdev/ and move some serial/tty/chardev doc files to
> Documentation/serial/  (or serial-tty/ or chardev/ or <suggestions>).
>
>
> A [git] diff for blockdev/ and serial/ looks like:
...
> Comments/thoughts?

That's a good start.  It would also be nice to create an "arch" subdirectory 
to move the arm, m68k, mips, blackfin, parisc, powerpc, s390, sparc, ia64, 
uml, and x86 directories into.  (Plus sgi-*, voyager.txt, zorro.txt...)

Rob
