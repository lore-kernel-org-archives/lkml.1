Return-Path: <linux-kernel-owner+w=401wt.eu-S1756687AbZA2S7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbZA2S7Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 13:59:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbZA2S7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 13:59:00 -0500
Received: from mga09.intel.com ([134.134.136.24]:41064 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708AbZA2S67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 13:58:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,345,1231142400"; 
   d="scan'208";a="485647124"
From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Organization: Intel Corporation
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: mmotm 2009-01-29-02-29 uploaded (wimax)
Date: Thu, 29 Jan 2009 10:58:49 -0800
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <200901291030.n0TAUhRI003046@imap1.linux-foundation.org> <4981EC35.1030306@oracle.com>
In-Reply-To: <4981EC35.1030306@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901291058.50466.inaky@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 January 2009, Randy Dunlap wrote:
> akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2009-01-29-02-29 has been uploaded to
> >
> >    http://userweb.kernel.org/~akpm/mmotm/
> >
> > and will soon be available at
> >
> >    git://git.zen-sources.org/zen/mmotm.git
>
> Build fails with:
>
> ERROR: "d_level_wimax" [net/wimax/wimax.ko] undefined!
> ERROR: "d_level_size_wimax" [net/wimax/wimax.ko] undefined!

On it, Toralf Foerster just reported it.

I got the fix, I am now verifying it.

How do you guys generate all this configs? I thought I had tried all
possible combinations and I guess I was wrong...

-- 
Inaky
