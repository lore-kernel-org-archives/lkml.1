Return-Path: <linux-kernel-owner+w=401wt.eu-S1754831AbXFUIUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831AbXFUIUq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 04:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbXFUIUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 04:20:36 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3276 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbXFUIUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 04:20:35 -0400
Message-ID: <467A34E7.1050107@shadowen.org>
Date: Thu, 21 Jun 2007 09:20:55 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: scripts/checkpatch.pl refers to non-existent Documentation/Documentation/volatile-considered-harmful.txt
References: <ada3b0m8hr0.fsf@cisco.com>
In-Reply-To: <ada3b0m8hr0.fsf@cisco.com>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> Commit 4a0df2ef added the following to scripts/checkpatch.pl:
> 
>     print "Use of volatile is usually wrong: see Documentation/volatile-considered-harmful.txt\n";
> 
> but Linus's tree has no such file.  not sure what the right thing to
> do here is, since I assume we do ultimately want something of the sort
> in Documentation...

That is a little unfortuanate for sure.  As Jasper correctly indicates
this file is coming soon to a linus tree near you and things will be
accurate.  Otherwise it can be obtained from the current -mm tarball.
It can also be found here on LWN:

	http://lwn.net/Articles/234017/

-apw
