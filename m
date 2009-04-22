Return-Path: <linux-kernel-owner+w=401wt.eu-S1756785AbZDVUBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785AbZDVUBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 16:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754707AbZDVUBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 16:01:01 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:60488 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553AbZDVUBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 16:01:00 -0400
Date: Wed, 22 Apr 2009 22:00:58 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: Coly Li <coly.li@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 4/7] mips alchemy: add parameter to au1x_counter1_read()
Message-ID: <20090422200058.GA24498@roarinelk.homelinux.net>
References: <49EF6A8C.2050300@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EF6A8C.2050300@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Howdy,

On Thu, Apr 23, 2009 at 03:05:48AM +0800, Coly Li wrote:
> This patch modifies parameter of au1x_counter1_read() from 'void' to 'struct
> clocksource *cs', which fixes compile warning for incompatible parameter type.

I sent an identical patch to linux-mips this morning.

Thanks!
	Manuel Lauss
