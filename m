Return-Path: <linux-kernel-owner+w=401wt.eu-S1759919AbYGQARG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759919AbYGQARG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 20:17:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752883AbYGQAQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 20:16:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40421 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751218AbYGQAQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 20:16:54 -0400
Date: Wed, 16 Jul 2008 17:16:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
Cc: yoichi_yuasa@tripeaks.co.jp, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove old broken Cobalt LCD driver
Message-Id: <20080716171640.4e1ae418.akpm@linux-foundation.org>
In-Reply-To: <20080715223132.e2d217e8.yoichi_yuasa@tripeaks.co.jp>
References: <20080715223132.e2d217e8.yoichi_yuasa@tripeaks.co.jp>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2008 22:31:32 +0900
Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp> wrote:

> Remove old broken Cobalt LCD driver.
> 
> Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

Why do we remove it, rather than unbreaking it?

Did some other driver replace it?  Does nobody need the driver any
more?
