Return-Path: <linux-kernel-owner+w=401wt.eu-S932286AbXBNOIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286AbXBNOIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 09:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbXBNOIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 09:08:21 -0500
Received: from [212.33.164.166] ([212.33.164.166]:33101 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751325AbXBNOIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 09:08:21 -0500
X-Greylist: delayed 859 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Feb 2007 09:08:19 EST
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 6/6] automatic tuning applied to some kernel components 
Date: Wed, 14 Feb 2007 16:56:43 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702141656.43301.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ebiederm wrote:
> At a quick glance max_threads and max_files appear even more to be
> DOS limits and not tunables and even less applicable to needing any
> tuning at all.  My gut feel is at worst these values may need a little
> better boot time defaults but otherwise they the should be good.

Autotuning max_threads and max_files by using some sort of rate-limiter could 
possibly be more useful than any kind of fixed default.


Thanks!

--
Al

