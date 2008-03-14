Return-Path: <linux-kernel-owner+w=401wt.eu-S1756879AbYCNBrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879AbYCNBrm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 21:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbYCNBrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 21:47:33 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:19208 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751970AbYCNBrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 21:47:32 -0400
Date: Fri, 14 Mar 2008 10:47:11 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc5-git3: Reported regressions from 2.6.24
Message-ID: <20080314014711.GA14995@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Natalie Protasevich <protasnb@gmail.com>
References: <200803140136.38549.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803140136.38549.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2008 at 01:36:37AM +0100, Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10025
> Subject		: Current git very broken on the Dreamcast
> Submitter	: Adrian McMenamin <adrian@newgolddream.dyndns.info>
> Date		: 2008-02-16 19:38 (27 days old)
> References	: http://lkml.org/lkml/2008/2/16/196
> Handled-By	: Kristoffer Ericson <kristoffer.ericson@gmail.com>
> 		  Magnus Damm <magnus.damm@gmail.com>
> 
I didn't realize this was on the regression list. This was fixed by
Magnus in 763a495a022ac26afb2940e768e86725c1c7e8c9.
