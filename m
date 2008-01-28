Return-Path: <linux-kernel-owner+w=401wt.eu-S1751452AbYA1FyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452AbYA1FyG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 00:54:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754558AbYA1Fxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 00:53:52 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46243 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753002AbYA1Fxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 00:53:51 -0500
Date: Sun, 27 Jan 2008 21:54:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Segaud <mathieu.segaud@regala.cx>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Convert reiserfs_ioctl() to an unlocked_ioctl
Message-Id: <20080127215405.91f4f6c6.akpm@linux-foundation.org>
In-Reply-To: <1200573848-1382-1-git-send-email-mathieu.segaud@regala.cx>
References: <1200573848-1382-1-git-send-email-mathieu.segaud@regala.cx>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I get a massive reject when applying this.  As usual.

I'm afraid that the days when one could prepare 2.6.x patches against the
2.6.x-1 tree are long past us.

Please resend after 2.6.25-rc1 or, better, redo against the
most-recently-released -mm kernel or, better, redo against
http://userweb.kernel.org/~akpm/mmotm/

