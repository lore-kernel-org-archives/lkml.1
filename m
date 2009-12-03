Return-Path: <linux-kernel-owner+w=401wt.eu-S1753532AbZLCHUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbZLCHUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 02:20:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbZLCHUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 02:20:52 -0500
Received: from ozlabs.org ([203.10.76.45]:40637 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075AbZLCHUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 02:20:51 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Helge Deller <deller@gmx.de>
Subject: Re: [PATCH] modules: don't export section names of empty sections via sysfs
Date: Thu, 3 Dec 2009 17:50:41 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-15-generic; KDE/4.3.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
       kyle@mcmartin.ca, akpm@linux-foundation.org,
       James.Bottomley@hansenpartnership.com, roland@redhat.com,
       dave@hiauly1.hia.nrc.ca, torvalds@linux-foundation.org
References: <20091202232915.GA2251@p100.box>
In-Reply-To: <20091202232915.GA2251@p100.box>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912031750.41240.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Dec 2009 09:59:15 am Helge Deller wrote:
> [PATCH] modules: don't export section names of empty sections via sysfs

Thanks, applied.

Ah, I see Linus snuck this in before the release.  Excellent.
Rusty.
