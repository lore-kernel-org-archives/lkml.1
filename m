Return-Path: <linux-kernel-owner+w=401wt.eu-S1753762AbZI3ARt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762AbZI3ARt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 20:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753560AbZI3ARs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 20:17:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60391 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753240AbZI3ARs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 20:17:48 -0400
Date: Tue, 29 Sep 2009 17:17:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: linux-kernel@vger.kernel.org, rolandd@cisco.com, dwalker@fifo99.com,
       cesarb@cesarb.net
Subject: Re: [PATCH] WARN_ONCE(): use bool for boolean flag
Message-Id: <20090929171718.4bafa915.akpm@linux-foundation.org>
In-Reply-To: <1254265948-29729-1-git-send-email-cesarb@cesarb.net>
References: <4AC2943E.2070502@cesarb.net>
	<1254265948-29729-1-git-send-email-cesarb@cesarb.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Sep 2009 20:12:28 -0300
Cesar Eduardo Barros <cesarb@cesarb.net> wrote:

> Commit 70867453092297be9afb2249e712a1f960ec0a09 changed printk_once()
> to use bool instead of int for its guard variable. Do the same change
> to WARN_ONCE() and WARN_ON_ONCE(), for the same reasons.
> 

Again, it would be useful were this changelog to describe the impact
upon kernel code size, please.

