Return-Path: <linux-kernel-owner+w=401wt.eu-S1752191Ab0AVIgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab0AVIgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 03:36:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027Ab0AVIgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 03:36:20 -0500
Received: from one.firstfloor.org ([213.235.205.2]:38122 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab0AVIgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 03:36:19 -0500
Date: Fri, 22 Jan 2010 09:36:16 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Valdis.Kletnieks@vt.edu
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       x86@kernel.org, robert.richter@amd.com, oprofile-list@lists.sf.net
Subject: Re: [PATCH] Add Xeon 7500 series support to oprofile
Message-ID: <20100122083616.GA20592@one.firstfloor.org>
References: <20100121222627.GA22897@basil.fritz.box> <28939.1264126458@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28939.1264126458@localhost>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> I'll bite - why a hex constant rather than the decimal values nearby?

Why not?

> 
> Also, should we do something about *cpu_type so it isn't confusing on a 7500
> reporting itself as a i7?

No, that wouldn't be compatible to oprofile userland.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
