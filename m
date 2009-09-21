Return-Path: <linux-kernel-owner+w=401wt.eu-S1755196AbZIULm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbZIULm2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 07:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbZIULm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 07:42:28 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:44190 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751386AbZIULm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 07:42:27 -0400
Subject: Re: [PATCH v2] arm: export "W" macro just for assembly code
From: Catalin Marinas <catalin.marinas@arm.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Alexey Dobriyan <adobriyan@gmail.com>
In-Reply-To: <20090920194012.GA22062@Chamillionaire.breakpoint.cc>
References: <20090917091237.8258.29171.stgit@pc1117.cambridge.arm.com>
	 <20090918193422.GA6601@n2100.arm.linux.org.uk>
	 <20090920194012.GA22062@Chamillionaire.breakpoint.cc>
Content-Type: text/plain
Organization: ARM Ltd
Date: Mon, 21 Sep 2009 12:41:28 +0100
Message-Id: <1253533288.1541.87.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Sep 2009 11:41:29.0329 (UTC) FILETIME=[757D6E10:01CA3AB0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-09-20 at 21:40 +0200, Sebastian Andrzej Siewior wrote:
> Russel, I've added a new patch description for this patch since my
> rename edition was a little larger.

I already added a patch with the modified description in my for-rmk
branch. I'm not sure Russell had time to pull it.

-- 
Catalin

