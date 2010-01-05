Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806Ab0AEPWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab0AEPWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 10:22:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754388Ab0AEPWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 10:22:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754708Ab0AEPWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 10:22:10 -0500
Date: Tue, 5 Jan 2010 10:21:29 -0500
From: Jason Baron <jbaron@redhat.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>, Greg Banks <gnb@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: dynamic debug during boot / module insert?
Message-ID: <20100105152128.GB2662@redhat.com>
References: <20100101165104.GA9062@comet.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100101165104.GA9062@comet.dominikbrodowski.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 01, 2010 at 05:51:04PM +0100, Dominik Brodowski wrote:
> Hey,
> 
> is there any boot option / other tweak to enable some dynamic debug calls
> early on, even before userspace / debugfs is up and available? Also, is
> there a chance to enable dynamic debug calls for a module just to be loaded
> / initialized?
> 
> Best,
> 	Dominik

hi,

not at the moment, but its definitely on the 'todo' list.

thanks,

-Jason
