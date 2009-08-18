Return-Path: <linux-kernel-owner+w=401wt.eu-S1751902AbZHRU2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbZHRU2N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 16:28:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751731AbZHRU2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 16:28:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60278 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689AbZHRU2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 16:28:12 -0400
Date: Tue, 18 Aug 2009 16:27:35 -0400
From: Dave Jones <davej@redhat.com>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Paris <eparis@redhat.com>, James Morris <jmorris@namei.org>
Subject: Re: Make LSM_MMAP_MIN_ADDR default match its help text.
Message-ID: <20090818202735.GA13579@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andreas Schwab <schwab@linux-m68k.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Eric Paris <eparis@redhat.com>, James Morris <jmorris@namei.org>
References: <200908172100.n7HL08SR001061@hera.kernel.org> <20090818174736.GA23352@redhat.com> <m2prasq3q2.fsf@igel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2prasq3q2.fsf@igel.home>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 10:14:29PM +0200, Andreas Schwab wrote:
 > Dave Jones <davej@redhat.com> writes:
 > 
 > >  config LSM_MMAP_MIN_ADDR
 > >  	int "Low address space for LSM to from user allocation"
 > 
 > This sentence no verb.

Oops. I accidentally that.

Thanks.

	Dave 

