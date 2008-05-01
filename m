Return-Path: <linux-kernel-owner+w=401wt.eu-S1756985AbYEAFlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985AbYEAFlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 01:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753153AbYEAFlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 01:41:05 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:58358 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbYEAFlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 01:41:02 -0400
Subject: Re: [patch 00/13] vfs: add helpers to check r/o bind mounts
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, ezk@cs.sunysb.edu, mhalcrow@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080424113950.818688067@szeredi.hu>
References: <20080424113950.818688067@szeredi.hu>
Content-Type: text/plain
Date: Wed, 30 Apr 2008 22:40:57 -0700
Message-Id: <1209620457.4461.59.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-04-24 at 13:39 +0200, Miklos Szeredi wrote:
> R/O bind mounts patches have been reviewed numerous times.  Still a
> relatively large number of places remained where checking for R/O
> mounts was missed.

In all the other... erm... interesting discussion, I missed this point.

Were there some bits outside of the nfsd code where I missed the r/o
mount checks?

-- Dave

