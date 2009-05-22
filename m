Return-Path: <linux-kernel-owner+w=401wt.eu-S1757460AbZEVUFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460AbZEVUFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 16:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756939AbZEVUFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 16:05:38 -0400
Received: from solo.fdn.fr ([80.67.169.19]:40058 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960AbZEVUFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 16:05:38 -0400
Date: Fri, 22 May 2009 22:05:36 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: "Michael S. Zick" <lkml@morethan.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Message-ID: <20090522200536.GZ10166@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	"Michael S. Zick" <lkml@morethan.org>,
	Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
References: <200905221139.26941.lkml@morethan.org> <200905221343.30638.lkml@morethan.org> <20090522192329.GF846@one.firstfloor.org> <200905221453.41895.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200905221453.41895.lkml@morethan.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael S. Zick, le Fri 22 May 2009 14:53:39 -0500, a écrit :
> Ref: http://developer.intel.com/Assets/PDF/manual/253666.pdf
> Manual page: 3-590  PDF page: 638
> Summary: Processors prior to P-4 can take an interrupt between
> the read cycle and the write cycle. Which is why opcode 0xF0 exists.

Where do you see page 638/639 talking about interrupts?  It talks about
multi-processor machines.

Samuel
