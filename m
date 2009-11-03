Return-Path: <linux-kernel-owner+w=401wt.eu-S1756001AbZKCBzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001AbZKCBzn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 20:55:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756700AbZKCBzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 20:55:42 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34540 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756703AbZKCBzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 20:55:42 -0500
Date: Mon, 2 Nov 2009 17:55:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rodolfo Giometti <giometti@linux.it>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pps: events reporting fix up.
Message-Id: <20091102175542.3b6e993e.akpm@linux-foundation.org>
In-Reply-To: <1256807349-20540-1-git-send-email-giometti@linux.it>
References: <1256807349-20540-1-git-send-email-giometti@linux.it>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Oct 2009 10:09:09 +0100
Rodolfo Giometti <giometti@linux.it> wrote:

> PPS events must be recorded according to PPS's mode settings.
> 
> Signed-off-by: Rodolfo Giometti <giometti@linux.it>
> Tested-by: William S. Brasher <billb958@door.net>
> Tested-by: Reg Clemens <clemens@dwf.com>

Please send a complete changelog for this patch also.
