Return-Path: <linux-kernel-owner+w=401wt.eu-S1759514AbYCEEWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759514AbYCEEWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 23:22:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755070AbYCEEWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 23:22:16 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754817AbYCEEWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 23:22:16 -0500
Date: Tue, 4 Mar 2008 23:21:56 -0500
From: Rik van Riel <riel@redhat.com>
To: minchan Kim <minchan.kim@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [patch 11/20] No Reclaim LRU Infrastructure
Message-ID: <20080304232156.10fe473a@bree.surriel.com>
In-Reply-To: <47CDEA95.9050507@gmail.com>
References: <20080304225157.573336066@redhat.com>
	<20080304225227.455963956@redhat.com>
	<47CDEA95.9050507@gmail.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Mar 2008 09:34:29 +0900
minchan Kim <minchan.kim@gmail.com> wrote:

> We don't use is_lru_page any more.
> It cause warning at compile time.
> 
> We can remove is_lru_page local variable.

I have applied this fix too.  Thank you.

-- 
All rights reversed.
