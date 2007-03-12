Return-Path: <linux-kernel-owner+w=401wt.eu-S1751721AbXCLSqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721AbXCLSqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 14:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753AbXCLSqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 14:46:47 -0400
Received: from station18k.dscga.com ([192.24.222.18]:47822 "EHLO
	suzuka.mcnaught.org" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbXCLSqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 14:46:46 -0400
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org, Con Kolivas <kernel@kolivas.org>,
       amanda-hackers@amanda.org, Matt Mackall <mpm@selenic.com>,
       Andrew Morton <akpm@linux-foundation.org>, ck@vds.kolivas.org
Subject: Re: RSDL for 2.6.21-rc3- 0.29
References: <20070311013506.GD10459@waste.org>
	<200703120604.42776.gene.heskett@gmail.com>
	<873b4alj52.fsf@suzuka.mcnaught.org>
	<200703121428.29947.gene.heskett@gmail.com>
From: Douglas McNaught <doug@mcnaught.org>
Date: Mon, 12 Mar 2007 14:46:45 -0400
In-Reply-To: <200703121428.29947.gene.heskett@gmail.com> (Gene Heskett's
 message of "Mon, 12 Mar 2007 14:28:29 -0400")
Message-ID: <87wt1mjo4q.fsf@suzuka.mcnaught.org>
User-Agent: Gnus/5.1006 (Gnus v5.10.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett <gene.heskett@gmail.com> writes:

> I'd considered it, but with 32 dle entries, the whole strace output would 
> be terrabytes & I don't have THAT much disk.  Not to mention it traces 
> only the parent process, so tar would be merrily marching along to its 
> own drummer and not traced I'm  afraid.

$ strace -ff 

-Doug
