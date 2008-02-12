Return-Path: <linux-kernel-owner+w=401wt.eu-S1761387AbYBLGXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761387AbYBLGXo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 01:23:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754644AbYBLGXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 01:23:37 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57955 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753464AbYBLGXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 01:23:36 -0500
Date: Mon, 11 Feb 2008 22:21:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [patch] avoid kmemcheck warning in epoll
Message-Id: <20080211222149.4f0b076f.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0802112157270.6351@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0802112157270.6351@alien.or.mcafeemobile.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008 22:03:21 -0800 (PST) Davide Libenzi <davidel@xmailserver.org> wrote:
>

Thanks.

> Subject: [patch] avoid kmemcheck warning in epoll

I converted this to "epoll: avoid kmemcheck warning", as per
SubmittingPatches's section 14.

