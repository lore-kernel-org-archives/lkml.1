Return-Path: <linux-kernel-owner+w=401wt.eu-S1760355AbYCGGI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760355AbYCGGI5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 01:08:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754911AbYCGGI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 01:08:28 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:32914 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562AbYCGGIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 01:08:11 -0500
Date: Thu, 6 Mar 2008 20:53:10 -0800
From: Greg KH <greg@kroah.com>
To: Kohei KaiGai <kaigai@ak.jp.nec.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       "Andrew G. Morgan" <morgan@kernel.org>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] exporting capability name/code pairs (final#2)
Message-ID: <20080307045310.GA913@kroah.com>
References: <47C25AE9.7080305@ak.jp.nec.com> <47C25BE3.9050905@ak.jp.nec.com> <47C42854.8030000@kernel.org> <20080226205810.GA4523@sergelap.austin.ibm.com> <47D0C4FC.1020900@ak.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D0C4FC.1020900@ak.jp.nec.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2008 at 01:30:52PM +0900, Kohei KaiGai wrote:
> Who can pick up this patch to the upstreamed tree?
>
> It's unclear for me, because no one is explicitly listed
> as a maintainer of capabilities....

If the security maintainer (Chris Wright) signs off on it, I'll be glad
to take this through my tree as it does need the kobject changes to work
properly.

thanks,

greg k-h
