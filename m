Return-Path: <linux-kernel-owner+w=401wt.eu-S1757279AbYCaK2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279AbYCaK2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 06:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756971AbYCaK2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 06:28:24 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40281 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169AbYCaK2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 06:28:23 -0400
Subject: Re: RFC:   Writing Solaris Device Drivers in Java
From: Peter Zijlstra <peterz@infradead.org>
To: Peter Teoh <htmldeveloper@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>
In-Reply-To: <47F0491F.4050804@gmail.com>
References: <47F0491F.4050804@gmail.com>
Content-Type: text/plain
Date: Mon, 31 Mar 2008 12:28:13 +0200
Message-Id: <1206959293.8514.636.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-03-31 at 10:14 +0800, Peter Teoh wrote:
> Interesting read:
> 
> http://research.sun.com/techrep/2006/smli_tr-2006-156.pdf
> 
> Personal comments:
> 
> Since KVM and Xen/OpenVZ etc other virtual machines are beginning to pop 
> up - I don't see why it inhibits (in spite of the many initial 
> difficulties as mentioned in the paper) the growth of using Java for 
> device drivers development.   Contrast it against udev - esp in terms of 
> usability/supportability/extensibility etc.   udev is a Linux thing, 
> whereas Java is at industry level.   If everyone write applications 
> device drivers using Java (minus the extreme hardware arch specific 
> stuff, but supports all the low level protocol specific stuff like 
> TCP/IP, NFS, USB etc) then I think it has potential to compete against C 
> lang - the monopolizer till today in the kernel world 
> (Windows/MacOS/Linux/BSD etc).   Ie, imagine using a drivers written for 
> the Solaris in Linux, won't it be cool?


LOL.. good joke!

But as others have pointed out, you missed April's fools by 1 day.

