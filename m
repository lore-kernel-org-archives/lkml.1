Return-Path: <linux-kernel-owner+w=401wt.eu-S1755683AbYDUKRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683AbYDUKRb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 06:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbYDUKRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 06:17:23 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:8753 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbYDUKRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:17:22 -0400
Message-ID: <480C69B0.5060304@de.ibm.com>
Date: Mon, 21 Apr 2008 12:17:20 +0200
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: subrata@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, ltp-list <ltp-list@lists.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: [LTP] [ANNOUNCE] gcov-kernel patches for Linux 2.6.25.
References: <bb33bcf20804210152t676d9be3x6d5f403acdb7180@mail.gmail.com> <1208770501.5051.24.camel@subratamodak.linux.ibm.com>
In-Reply-To: <1208770501.5051.24.camel@subratamodak.linux.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subrata Modak wrote:
> There has been a recent concern that these Patches does not compile on
> the x86_64 architecture. We recently had this problem with the 2.6.24
> GCOV Patches. Do you have any fixes for this ?

As far as I remember the x86_64 related problems of the gcov-kernel patch were not compile problems, but non-trivial run-time errors when starting the init process. I can't debug those myself so we'd need someone with x86_64 kernel knowledge to help out. I'm planning to post the gcov-kernel patch rewrite later on and I'd like to postpone this particular discussion until the new code base has been published.


Regards,
  Peter
