Return-Path: <linux-kernel-owner+w=401wt.eu-S1753486AbZBDDgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbZBDDgp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 22:36:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbZBDDgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 22:36:36 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:55739 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbZBDDgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 22:36:36 -0500
Date: Wed, 4 Feb 2009 09:06:28 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kamezawa.hiroyu@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       nishimura@mxp.nes.nec.co.jp, lizf@cn.fujitsu.com, linux-mm@kvack.org
Subject: Re: [-mm patch] Show memcg information during OOM (v3)
Message-ID: <20090204033628.GA4456@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090203172135.GF918@balbir.in.ibm.com> <20090203144647.09bf9c97.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090203144647.09bf9c97.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton <akpm@linux-foundation.org> [2009-02-03 14:46:47]:

> -	 if (ret < 0) {
> +	if (ret < 0) {
i
Andrew sorry about the whitespace issues, I ran checkpatch and it did
not show up there, but I clearly see it in the patch. Do you want me
to send you a fixed patch?

-- 
	Balbir
