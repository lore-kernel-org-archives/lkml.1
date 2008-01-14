Return-Path: <linux-kernel-owner+w=401wt.eu-S1755621AbYAOQv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621AbYAOQv6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 11:51:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750991AbYAOQvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 11:51:51 -0500
Received: from waste.org ([66.93.16.53]:55768 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733AbYAOQvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 11:51:50 -0500
Subject: Re: [PATCH 0/7] Create and populate toplevel tests/ directory
From: Matt Mackall <mpm@selenic.com>
To: ananth@in.ibm.com
Cc: lkml <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       mingo@elte.hu, ak@suse.de, sam@ravnborg.org
In-Reply-To: <20080110115428.GA26577@in.ibm.com>
References: <20080110115428.GA26577@in.ibm.com>
Content-Type: text/plain
Date: Mon, 14 Jan 2008 16:55:41 -0600
Message-Id: <1200351341.3877.56.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-10 at 17:24 +0530, Ananth N Mavinakayanahalli wrote:
> The following series of patches create and populate the toplevel tests/
> directory. This will henceforth be the place where all in-kernel tests
> live.
> 
> All patches against 2.6.24-rc6-mm1

There's a small test I stuck at the end of lib/sort.c, if you're in the
mood. And there's another large set of tests in the cryptoapi.

-- 
Mathematics is the supreme nostalgia of our time.

