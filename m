Return-Path: <linux-kernel-owner+w=401wt.eu-S1753194AbXKUSoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbXKUSoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 13:44:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbXKUSo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 13:44:29 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453AbXKUSo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 13:44:28 -0500
Date: Wed, 21 Nov 2007 13:44:03 -0500
From: Don Zickus <dzickus@redhat.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH] Add the word 'Warning' in check_nmi_watchdog() output
Message-ID: <20071121184403.GD12071@redhat.com>
References: <1195665260-14641-1-git-send-email-dzickus@redhat.com> <20071121103459.0b9b0302@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071121103459.0b9b0302@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2007 at 10:34:59AM -0800, Arjan van de Ven wrote:
> On Wed, 21 Nov 2007 12:14:20 -0500
> Don Zickus <dzickus@redhat.com> wrote:
> 
> > Our automated test suite looks for keywords like error, fail, warning
> > in the boot log.  In the case when the nmi watchdog is determined to
> > be stuck in check_nmi_watchdog(), none of those keywords are
> > displayed.
> 
> 
> please make it at least consistent with the other kernel level bad
> things, and use "WARNING:"....

Good point.  I'll repost.

Cheers,
Don

