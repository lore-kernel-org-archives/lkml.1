Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753677AbYLRC7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677AbYLRC7E (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 21:59:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750947AbYLRC6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 21:58:53 -0500
Received: from cantor.suse.de ([195.135.220.2]:44631 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbYLRC6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 21:58:52 -0500
Date: Wed, 17 Dec 2008 18:58:40 -0800
From: Greg KH <gregkh@suse.de>
To: Mike Travis <travis@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@redhat.com>,
        Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: Re: [PATCH 1/1]: sysfs: add documentation to cputopology.txt for
	system cpumasks
Message-ID: <20081218025840.GA18326@suse.de>
References: <20081216042645.629941000@polaris-admin.engr.sgi.com> <20081216042646.088194000@polaris-admin.engr.sgi.com> <200812172223.53079.rusty@rustcorp.com.au> <20081217184011.GB30724@suse.de> <494979C6.7060003@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <494979C6.7060003@sgi.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 02:14:30PM -0800, Mike Travis wrote:
> Subject: sysfs: add documentation to cputopology.txt for system cpumasks
> 
> Add information to cputopology.txt explaining the output of various
> system cpumask's.
> 
> Signed-off-by: Mike Travis <travis@sgi.com>

Looks good to me, thanks for doing this.

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
