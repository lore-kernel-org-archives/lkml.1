Return-Path: <linux-kernel-owner+w=401wt.eu-S1760131AbXFUT4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760131AbXFUT4l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 15:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759884AbXFUT4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 15:56:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759729AbXFUT4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 15:56:14 -0400
To: davids@webmaster.com
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: how about mutual compatibility between Linux's GPLv2 and GPLv3?
References: <MDEHLPKNGKAHNMBLJOLKMEHNEMAC.davids@webmaster.com>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 21 Jun 2007 16:56:03 -0300
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKMEHNEMAC.davids@webmaster.com> (David Schwartz's message of "Thu\, 21 Jun 2007 11\:29\:17 -0700")
Message-ID: <orps3pjd4c.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 21, 2007, "David Schwartz" <davids@webmaster.com> wrote:

> Alexandre Oliva wrote:

>> However, if GPLv3 had a permission to combine/link with code under
>> GPLv2, *and* Linux (and any other projects interested in mutual
>> compatibility) introduced an additional permission to combine/link
>> with code under GPLv3 (or even GPLv3+, constrained by some condition
>> if you will), then:

> Wouldn't that defeat the entire purpose of the GPLv3? Couldn't I take any
> GPLv3 program, combine it with a few lines of Linux code, and Tivoize the
> result?

No.  This is not permission to relicense.  This is permission to
combine.  Each author still gets to enforce the terms of her own code.
So a tivoizer would have to take out the code licensed under the
GPLv3, and use only the code that permits tivoization.  Same as today,
but without the possibility of cooperation for licensees who don't
tivoize.

Sorry if this wasn't obvious, it was for me.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
