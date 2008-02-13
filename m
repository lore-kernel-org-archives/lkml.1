Return-Path: <linux-kernel-owner+w=401wt.eu-S933221AbYBMTkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933221AbYBMTkS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 14:40:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756075AbYBMTj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 14:39:59 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60894 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754769AbYBMTj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 14:39:58 -0500
Date: Wed, 13 Feb 2008 11:39:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, a.p.zijlstra@chello.nl
Subject: Re: [RFC v2 PATCH] RTTIME watchdog timer proc interface
Message-Id: <20080213113907.5aec8ba3.akpm@linux-foundation.org>
In-Reply-To: <47B32CD2.3040200@ct.jp.nec.com>
References: <47B220A6.5090707@ct.jp.nec.com>
	<20080213011310.e27dd9cf.akpm@linux-foundation.org>
	<47B32CD2.3040200@ct.jp.nec.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008 09:45:54 -0800
Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> > 
> >> And /proc/<pid>/task/<tid>/rttime is also accessible.
> > 
> > Please describe the format in the changelog.
> 
> I'm sorry I cannot catch your meaning.

Please include an example of the output of
`cat /proc/<pid>/task/<tid>/rttime' in the changelog so that we
can see precisely what interface you are proposing.
