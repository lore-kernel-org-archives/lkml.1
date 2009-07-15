Return-Path: <linux-kernel-owner+w=401wt.eu-S1756176AbZGOTkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbZGOTkx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 15:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756142AbZGOTkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 15:40:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44615 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756139AbZGOTkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 15:40:52 -0400
Date: Wed, 15 Jul 2009 12:40:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: dougthompson@xmission.com
Cc: bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] edac: mpc85xx add P2020DS support
Message-Id: <20090715124011.276d2c88.akpm@linux-foundation.org>
In-Reply-To: <4a5e1429.HffMs6pyjuaYD//x%dougthompson@xmission.com>
References: <4a5e1429.HffMs6pyjuaYD//x%dougthompson@xmission.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jul 2009 11:38:49 -0600
dougthompson@xmission.com wrote:

> Based on Kumar's new compatible types patch, add P2020 into
> MPC85xx EDAC compatible lists so that EDAC can recognize
> P2020 meomry controller and L2 cache controller and export
> the relevant fields to sysfs.
> 
> EDAC MPC85xx DDR3 support is needed if DDR3 memory stick is
> installed on a P2020DS board so that EDAC core can recognize
> DDR3 memory type.
> 
> Signed-off-by: Yang Shi <yang.shi@windriver.com>
> Acked-by: Dave Jiang <djiang@mvista.com>
> Signed-off-by: Doug Thompson <dougthompson@xmission.com>

The way the first two patches were sent indicates that you were their
primary author.  Was that intended?

Do you think that any/all of these should be in 2.6.31?  2.6.30.x?  If
so, why?

Thanks.
