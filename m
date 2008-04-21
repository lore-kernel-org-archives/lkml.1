Return-Path: <linux-kernel-owner+w=401wt.eu-S1756048AbYDUJfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048AbYDUJfg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 05:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754151AbYDUJfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 05:35:25 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36408 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753973AbYDUJfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 05:35:24 -0400
Subject: Re: [LTP] [ANNOUNCE] gcov-kernel patches for Linux 2.6.25.
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: Peter 1 Oberparleiter <Peter.Oberparleiter@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, ltp-list <ltp-list@lists.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Oberparleiter <oberparleiter@googlemail.com>,
       Peter Oberparleiter <peter.oberparleiter@gmx.de>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
In-Reply-To: <bb33bcf20804210152t676d9be3x6d5f403acdb7180@mail.gmail.com>
References: <bb33bcf20804210152t676d9be3x6d5f403acdb7180@mail.gmail.com>
Content-Type: text/plain
Organization: IBM
Date: Mon, 21 Apr 2008 15:05:01 +0530
Message-Id: <1208770501.5051.24.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

There has been a recent concern that these Patches does not compile on
the x86_64 architecture. We recently had this problem with the 2.6.24
GCOV Patches. Do you have any fixes for this ?

CC-ing Kamalesh, who reported this Problem. Kamalesh, can you please
exemplify your problem to Peter.

Regards--
Subrata

On Mon, 2008-04-21 at 14:22 +0530, Subrata Modak wrote:
> Hi,
> 
> GCOV-kernel patches for Linux 2.6.25 are now available for downloads
> at:
> 
> http://ltp.cvs.sourceforge.net/ltp/utils/analysis/gcov-kernel/,
> 
> You can use them for generating code coverage on 2.6,25.
> 
> -- 
> Regards & Thanks--
> Subrata
> -------------------------------------------------------------------------
> This SF.net email is sponsored by the 2008 JavaOne(SM) Conference 
> Don't miss this year's exciting event. There's still time to save $100. 
> Use priority code J8TL2D2. 
> http://ad.doubleclick.net/clk;198757673;13503038;p?http://java.sun.com/javaone
> _______________________________________________ Ltp-list mailing list Ltp-list@lists.sourceforge.net https://lists.sourceforge.net/lists/listinfo/ltp-list

