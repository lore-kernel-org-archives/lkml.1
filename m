Return-Path: <linux-kernel-owner+w=401wt.eu-S1757106AbZBWTAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106AbZBWTAz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 14:00:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754186AbZBWTAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 14:00:47 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41680 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752984AbZBWTAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 14:00:46 -0500
Date: Mon, 23 Feb 2009 19:57:58 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Metzger, Markus T" <markus.t.metzger@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] forget_original_parent: split out the un-ptrace
	part
Message-ID: <20090223185758.GA24226@redhat.com>
References: <20090211211216.GA16847@redhat.com> <20090220022746.8852CFC2F7@magilla.sf.frob.com> <20090223164632.GA16294@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090223164632.GA16294@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Argh. Sorry to all for the noise, I should not have replied today...

On 02/23, Oleg Nesterov wrote:
>
> On 02/19, Roland McGrath wrote:
> >
> > In fact, that seems
> > like a new hole, period--without the short-circuit optimization.
>
> I think you are right, the current code looks racy too.

No, the current code is fine. And I just misunderstood you.

Oleg.

