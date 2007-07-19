Return-Path: <linux-kernel-owner+w=401wt.eu-S965651AbXGSRIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965651AbXGSRIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938451AbXGSRHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:07:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939205AbXGSRH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:07:29 -0400
Date: Thu, 19 Jul 2007 12:59:32 -0400
From: Don Zickus <dzickus@redhat.com>
To: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>, vgoyal@in.ibm.com,
       Neil Horman <nhorman@redhat.com>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, Dan Aloni <da-x@monatomic.org>
Subject: Re: Determine version of kernel that produced vmcore
Message-ID: <20070719165932.GO9623@redhat.com>
References: <20070716123633.GA10920@in.ibm.com> <20070718230740oomichi@mail.jp.nec.com> <20070719163915.GN9623@redhat.com> <20070719164953.GA5381@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070719164953.GA5381@suse.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2007 at 06:49:53PM +0200, Bernhard Walle wrote:
> * Don Zickus <dzickus@redhat.com> [2007-07-19 18:39]:
> > 
> > I am not a big fan of this approach as it forces distros to require
> > kexec-tools when building a kernel.  Even Joe Hacker who wants a custom
> > kernel (and not interested in kexec) would have to not only download the
> > kernel.src.rpm but kexec-tools just to build a kernel that probably
> > doesn't have kexec enabled.
> 
> He would have to download makedumpfile, not kexec-tools.

My apologies.  Red Hat packages makedumpfile under kexec-tools, hence my
confusion.

Cheers,
Don
