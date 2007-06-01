Return-Path: <linux-kernel-owner+w=401wt.eu-S1763438AbXFASWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763438AbXFASWo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 14:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762136AbXFASWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 14:22:38 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:50049 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762098AbXFASWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 14:22:37 -0400
Date: Fri, 1 Jun 2007 11:22:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 1/1] document Acked-by:
Message-Id: <20070601112225.80a8be84.akpm@linux-foundation.org>
In-Reply-To: <20070601181414.GC7968@redhat.com>
References: <200706010209.l51299kN000531@shell0.pdx.osdl.net>
	<20070601181414.GC7968@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2007 14:14:14 -0400
Dave Jones <davej@redhat.com> wrote:

> On Thu, May 31, 2007 at 07:09:10PM -0700, Andrew Morton wrote:
>  > From: Andrew Morton <akpm@linux-foundation.org>
>  > 
>  > Explain what we use Acked-by: for, and how it differs from Signed-off-by:
>  > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>  > +
>  > +If a person was not directly involved in the preparation or handling of a
>  > +patch but wishes to signify and record their approval of it then they can
>  > +arrange to have an Acked-by: line added to the patch's changelog.
> 
> Acked-by: Dave Jones <davej@redhat.com>

What, no Tested-by: ?
