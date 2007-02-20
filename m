Return-Path: <linux-kernel-owner+w=401wt.eu-S932805AbXBTKHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805AbXBTKHL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 05:07:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932809AbXBTKHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 05:07:10 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:4629 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932805AbXBTKHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 05:07:09 -0500
Message-ID: <45DAC822.3040904@shadowen.org>
Date: Tue, 20 Feb 2007 10:06:26 +0000
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-mm2
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org>
In-Reply-To: <20070217215146.30e7ffa3.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

> - Judging by the number of times I get asked "is there a git tree for -mm",
>   nobody is reading the boilerplate.  Here it is again:

The git tree version of -mm seems to be sick.  A fetch of the tag gives
you something but it is "significantly" (200k lines of diff) away from
what patching a virgin tree gives you.  The 'last' patch seems to be:

    scsi-megaraid_sas-throttle-io-if-fw-is-busy

-apw
