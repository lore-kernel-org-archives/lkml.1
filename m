Return-Path: <linux-kernel-owner+w=401wt.eu-S1756181AbYG0NSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbYG0NSN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 09:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbYG0NR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 09:17:59 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34678 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbYG0NR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 09:17:59 -0400
Date: Sun, 27 Jul 2008 15:17:41 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Nathan Lynch <ntl@pobox.com>
Cc: linux-kernel@vger.kernel.org, Badari Pulavarty <pbadari@us.ibm.com>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] drivers/base/memory.c: fix fallout from sysdev API changes
Message-ID: <20080727131741.GC28253@one.firstfloor.org>
References: <20080727042633.GM9594@localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080727042633.GM9594@localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2008 at 11:26:34PM -0500, Nathan Lynch wrote:
> drivers/base/memory.c:280: warning: initialization from incompatible pointer type

Thanks looks good. I assume Andrew or Greg will merge it.

-Andi
