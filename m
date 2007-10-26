Return-Path: <linux-kernel-owner+w=401wt.eu-S1764739AbXJZU77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764739AbXJZU77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 16:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757408AbXJZU7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 16:59:49 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37440 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754974AbXJZU7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 16:59:48 -0400
Date: Fri, 26 Oct 2007 13:55:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [0/3] Distributed storage. Mirror algo extension for automatic
 recovery.
Message-Id: <20071026135538.d22125a2.akpm@linux-foundation.org>
In-Reply-To: <20071018191741.GA848@2ka.mipt.ru>
References: <20071018191741.GA848@2ka.mipt.ru>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2007 23:17:41 +0400
Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:

> I'm pleased to announce sixth release of the distributed storage
> subsystem, which allows to form a storage on top of remote and local
> nodes, which in turn can be exported to another storage as a node to
> form tree-like storages.

I went back and re-read last month's discussion and I'm not seeing any
reason why we shouldn't start thinking about merging this.

How close is it to that stage?  A peek at your development blog indicates
that things are still changing at a moderate rate?

