Return-Path: <linux-kernel-owner+w=401wt.eu-S1763588AbYD3ViU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763588AbYD3ViU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 17:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759834AbYD3ViJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 17:38:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51507 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753567AbYD3ViI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 17:38:08 -0400
Date: Wed, 30 Apr 2008 14:37:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: dpn@isomerica.net, torvalds@linux-foundation.org, davem@davemloft.net,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com, sfr@canb.auug.org.au
Subject: Re: Slow DOWN, please!!!
Message-Id: <20080430143717.61c6fff4.akpm@linux-foundation.org>
In-Reply-To: <200804302330.21743.rjw@sisk.pl>
References: <20080429.190352.137408408.davem@davemloft.net>
	<4818DAC4.0@isomerica.net>
	<20080430135938.82e46e67.akpm@linux-foundation.org>
	<200804302330.21743.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 23:30:20 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> > No, please test the sum-of-all-trees in linux-next.  If you hit problems
> > then, as part of the problem resolving process a developer _might_ ask you
> > to test one tree specifically, but that would be a pretty unusual
> > circumstance.
> 
> How bisectable is linux-next, BTW?

don't know.  Fully, one hopes.

Laurent Riffard did a successful bisection last month; I don't see many
other signs on the linux-next list.

