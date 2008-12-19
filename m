Return-Path: <linux-kernel-owner+w=401wt.eu-S1752552AbYLSQRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbYLSQRS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 11:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbYLSQRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 11:17:06 -0500
Received: from ns2.suse.de ([195.135.220.15]:33721 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431AbYLSQRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 11:17:04 -0500
Date: Fri, 19 Dec 2008 08:15:25 -0800
From: Greg KH <gregkh@suse.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@redhat.com>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] cpumask: add sysfs displays for configured and
	disabled cpu maps
Message-ID: <20081219161525.GC12492@suse.de>
References: <20081216042645.629941000@polaris-admin.engr.sgi.com> <20081216042646.088194000@polaris-admin.engr.sgi.com> <200812191716.25868.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812191716.25868.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2008 at 05:16:25PM +1030, Rusty Russell wrote:
> Based on tip/cpus4096 + .../rusty/linux-2.6-for-ingo.git/master +
> 	 x86-only-patches sent 12/15.
> 
> Signed-off-by: Mike Travis <travis@sgi.com>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Acked-by: Greg Kroah-Hartman
