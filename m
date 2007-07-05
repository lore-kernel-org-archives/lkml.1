Return-Path: <linux-kernel-owner+w=401wt.eu-S1762587AbXGEUZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762587AbXGEUZg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 16:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759803AbXGEUZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 16:25:29 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43375 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759783AbXGEUZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 16:25:28 -0400
Date: Thu, 5 Jul 2007 13:25:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 0/3] Use DATA_DATA in cris, powerpc and xtensa
Message-Id: <20070705132515.ee23df28.akpm@linux-foundation.org>
In-Reply-To: <20070703164534.492133618@polymtl.ca>
References: <20070703164534.492133618@polymtl.ca>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Jul 2007 12:45:34 -0400
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Hi,
> 
> I noticed that these architectures, as of 2.6.22-rc6-mm1, still doesn't use the
> DATA_DATA. Here are the patches for this.
> 

These three patches were missing changelogs.  The relevant arch maintainers
(who are presumably perfectly happy without DATA_DATA) are owed an explanation
of the reasons for these changes.  Please send me those explanations and I
shall update your changlogs, thanks.
