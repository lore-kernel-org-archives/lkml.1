Return-Path: <linux-kernel-owner+w=401wt.eu-S1756732AbYGAQpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732AbYGAQpH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 12:45:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbYGAQo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 12:44:56 -0400
Received: from ns.suse.de ([195.135.220.2]:51689 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbYGAQoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 12:44:55 -0400
Date: Tue, 1 Jul 2008 09:43:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 0/9] 2.6.25.10 -stable review
Message-ID: <20080701164322.GA32543@suse.de>
References: <20080701151835.GA3536@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701151835.GA3536@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 08:18:35AM -0700, Greg KH wrote:
> This is the start of the stable review cycle for the 2.6.25.10 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let us know.  If anyone is a maintainer of the proper subsystem, and
> wants to add a Signed-off-by: line to the patch, please respond with it.
> 
> These patches are sent out with a number of different people on the
> Cc: line.  If you wish to be a reviewer, please email stable@kernel.org
> to add your name to the list.  If you want to be off the reviewer list,
> also email us.
> 
> Responses should be made by July 3, 15:00:00 UTC.  Anything received
> after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.25.10-rc1.gz
> and the diffstat can be found below.

I have released 2.6.25.10-rc2 at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.25.10-rc2.gz
due to a build error in the -rc1 patch.

Sorry about that.

thanks,

greg k-h
