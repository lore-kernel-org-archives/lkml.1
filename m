Return-Path: <linux-kernel-owner+w=401wt.eu-S1755010AbYIKAlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010AbYIKAlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 20:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbYIKAlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 20:41:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40214 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752248AbYIKAlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 20:41:35 -0400
Date: Wed, 10 Sep 2008 17:41:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: oakad@exemail.com.au
Cc: linux-kernel@vger.kernel.org, oakad@yahoo.com
Subject: Re: [PATCH] memstick: fix MSProHG 8-bit interface mode support
Message-Id: <20080910174127.faf60c73.akpm@linux-foundation.org>
In-Reply-To: <1221059395-25724-1-git-send-email-oakad@exemail.com.au>
References: <1221059395-25724-1-git-send-email-oakad@exemail.com.au>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2008 01:09:55 +1000
oakad@exemail.com.au wrote:

> * Fix support of 8-bit interface mode

what was wrong with it?

> * Make driver to fallback to highest supported mode instead of always
>   falling back to serial

why?

> * Edit some macros for better conformance to Sony documentation

um, OK.

This is not pointless bookkeeping.  Someone (ie: me) needs to decide
whether this patch should be merged into 2.6.27.  You did not provide
sufficient information for the making of that decision.  Please always
do so.


