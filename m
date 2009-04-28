Return-Path: <linux-kernel-owner+w=401wt.eu-S1756472AbZD1OuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472AbZD1OuX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 10:50:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759209AbZD1OuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 10:50:07 -0400
Received: from relay.atmel.no ([80.232.32.139]:56721 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756024AbZD1OuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 10:50:06 -0400
Date: Tue, 28 Apr 2009 16:49:59 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Tim Abbott <tabbott@MIT.EDU>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>,
       Tim Abbott <tabbott@MIT.EDU>
Subject: Re: [PATCH 07/14] avr32: Use standard macros for .data.page_aligned
 section.
Message-ID: <20090428164959.021fd35b@hskinnemoen-d830>
In-Reply-To: <1240864388-26315-8-git-send-email-tabbott@mit.edu>
References: <1240864388-26315-1-git-send-email-tabbott@mit.edu>
	<1240864388-26315-2-git-send-email-tabbott@mit.edu>
	<1240864388-26315-3-git-send-email-tabbott@mit.edu>
	<1240864388-26315-4-git-send-email-tabbott@mit.edu>
	<1240864388-26315-5-git-send-email-tabbott@mit.edu>
	<1240864388-26315-6-git-send-email-tabbott@mit.edu>
	<1240864388-26315-7-git-send-email-tabbott@mit.edu>
	<1240864388-26315-8-git-send-email-tabbott@mit.edu>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Abbott wrote:
> Signed-off-by: Tim Abbott <tabbott@mit.edu>
> Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>

Assuming the definition of PAGE_ALIGNED_DATA is sane,

Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
