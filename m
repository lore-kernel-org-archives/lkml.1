Return-Path: <linux-kernel-owner+w=401wt.eu-S1753934AbYKJPSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbYKJPSc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 10:18:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347AbYKJPSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 10:18:22 -0500
Received: from lazybastard.de ([212.112.238.170]:59999 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbYKJPSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 10:18:21 -0500
Date: Mon, 10 Nov 2008 16:17:33 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       open-osd development <osd-dev@open-osd.org>,
       Mike Christie <michaelc@cs.wisc.edu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>,
       Sami.Iren@seagate.com, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/18 ver2] libosd: OSDv1 Headers
Message-ID: <20081110151733.GB16520@logfs.org>
References: <491073BB.4000900@panasas.com> <1225817046-5946-1-git-send-email-bharrosh@panasas.com> <4916F934.4090205@panasas.com> <20081109174509.GB5350@logfs.org> <4917F50B.3000905@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4917F50B.3000905@panasas.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 November 2008 10:47:07 +0200, Boaz Harrosh wrote:
> 
> If the assembly - size and offsets - of foo is exactly the same with or
> without the __packed, but the generated code is different then clearly this
> is a compiler bug. I've herd of this myth before, and at least with my
> gcc 4.1.2 there is no such bug. Either the structure gets packed, or there is
> no difference. All the places I have __packed in the code are absolutely must
> be so, stated by the protocol.

Ok, if current compilers are fine, I won't complain.

Jörn

-- 
There's nothing better for promoting creativity in a medium than
making an audience feel "Hmm ­ I could do better than that!"
-- Douglas Adams in a slashdot interview
