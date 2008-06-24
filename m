Return-Path: <linux-kernel-owner+w=401wt.eu-S1752297AbYFXPnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297AbYFXPnl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 11:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750770AbYFXPnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 11:43:32 -0400
Received: from relay1.sgi.com ([192.48.171.29]:51623 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750752AbYFXPnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 11:43:31 -0400
Date: Tue, 24 Jun 2008 10:43:30 -0500
From: Robin Holt <holt@sgi.com>
To: Alex Chiang <achiang@hp.com>, Robin Holt <holt@sgi.com>,
       tony.luck@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [BISECT] Boot failure on ia64.
Message-ID: <20080624154330.GQ10062@sgi.com>
References: <20080624123014.GJ10123@sgi.com> <20080624150851.GA3599@ldl.fc.hp.com> <20080624152620.GP10062@sgi.com> <20080624153447.GC3599@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080624153447.GC3599@ldl.fc.hp.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2008 at 09:34:47AM -0600, Alex Chiang wrote:
> * Robin Holt <holt@sgi.com>:
> > Here is the output.  This is from a different boot, but it does look the
> > same.
> 
> Hrm, that's odd. There's no debug output at all. Did you apply
> the patch?

...

> Anyone at SGI with more of a clue than me? (before I start digging
> in depth)

Jes hit this at about the same time.  He posted a patch and I verified
it works on sn2.  You should probably give it a try on some HP boxes as
well.

Thanks,
Robin
