Return-Path: <linux-kernel-owner+w=401wt.eu-S1757245AbYGAILb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245AbYGAILb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 04:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756043AbYGAILN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 04:11:13 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:18608 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756928AbYGAILJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 04:11:09 -0400
Date: Tue, 1 Jul 2008 17:08:01 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: akpm@linux-foundation.org, linux-kernel <linux-kernel@vger.kernel.org>,
       rth@twiddle.net, ink@jurassic.park.msu.ru, starvik@axis.com,
       jesper.nilsson@axis.com, ysato@users.sourceforge.jp,
       takata@linux-m32r.org, dhowells@redhat.com, mingo@redhat.com,
       tglx@linutronix.de, rmk@arm.linux.org.uk
Subject: Re: inflate: refactor inflate malloc code
Message-ID: <20080701080801.GC4726@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	akpm@linux-foundation.org,
	linux-kernel <linux-kernel@vger.kernel.org>, rth@twiddle.net,
	ink@jurassic.park.msu.ru, starvik@axis.com, jesper.nilsson@axis.com,
	ysato@users.sourceforge.jp, takata@linux-m32r.org,
	dhowells@redhat.com, mingo@redhat.com, tglx@linutronix.de,
	rmk@arm.linux.org.uk
References: <20080630152334.4acc28ef@surf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080630152334.4acc28ef@surf>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2008 at 03:23:34PM +0200, Thomas Petazzoni wrote:
> Because this patch touches several architectures, I've CC-ed all the
> architecture maintainers concerned by the patch. For H8300, no
> maintainer is listed in MAINTAINERS, so by looking at the git history,
> I assumed that Yoshinori Sato <ysato@users.sourceforge.jp> would be
> able to review the patch.
> 
There is, it's just hiding from you (the / is silent):

UCLINUX FOR RENESAS H8/300
P:      Yoshinori Sato
M:      ysato@users.sourceforge.jp
W:      http://uclinux-h8.sourceforge.jp/
S:      Supported

> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> 
sh bits:

Acked-by: Paul Mundt <lethal@linux-sh.org>
