Return-Path: <linux-kernel-owner+w=401wt.eu-S1753226AbZAEJBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbZAEJBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 04:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbZAEJBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 04:01:03 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:44598 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbZAEJBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 04:01:01 -0500
Date: Mon, 5 Jan 2009 10:02:39 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.29 -mm merge plans
Message-ID: <20090105090239.GB17530@uranus.ravnborg.org>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090105004300.19ed52d1.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew.

> sparc64-use-unsigned-long-long-for-u64.patch
> sparc64-fix-unsigned-long-long-warnings-in-drivers.patch

Please drop these two.
They are not complete (break build on certain configurations).
I will get back to them when I get my sparc64 setup functional.

	Sam
