Return-Path: <linux-kernel-owner+w=401wt.eu-S1756471AbYDRXlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471AbYDRXlh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 19:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbYDRXlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 19:41:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33947 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751677AbYDRXlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 19:41:25 -0400
Date: Fri, 18 Apr 2008 16:41:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: kkeil@suse.de, isdn4linux@listserv.isdn4linux.de,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       davem@davemloft.net
Subject: Re: [for 2.6.26] ISDN cleanups, ok for upstream?
Message-Id: <20080418164113.6863213d.akpm@linux-foundation.org>
In-Reply-To: <20080418225355.GA30189@havoc.gtf.org>
References: <20080418225355.GA30189@havoc.gtf.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2008 18:53:55 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> I don't know the current state of
> akpm's pull of jgarzik/misc-2.6.git#ALL.

oops.  It seems that I disabled it quite a long time ago.   I'll resurrect
it.

> The 'isdn-cleanups' branch of
> master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git isdn-cleanups

That merges cleanly against the small number of isdn patches which are
pending in -mm, so we're OK from that POV.

