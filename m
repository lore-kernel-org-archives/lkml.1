Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbXD0KPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbXD0KPb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 06:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755557AbXD0KPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 06:15:31 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:42338 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168AbXD0KPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 06:15:21 -0400
X-IronPort-AV: i="4.14,461,1170651600"; 
   d="scan'208"; a="28470093:sNHT23620240"
Subject: Re: [patch 00/33] 2.6.20-stable review
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
In-Reply-To: <20070426165445.GA1898@kroah.com>
References: <20070426165445.GA1898@kroah.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Fri, 27 Apr 2007 18:15:54 +0800
Message-Id: <1177668954.5969.18.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-26 at 09:54 -0700, Greg KH wrote:
> This is the start of the stable review cycle for the 2.6.20.10 release.
> There are 33 patches in this series, all will be posted as a response to
> this one.  If anyone has any issues with these being applied, please let
> us know.  If anyone is a maintainer of the proper subsystem, and wants
> to add a Signed-off-by: line to the patch, please respond with it.
> 
> These patches are sent out with a number of different people on the Cc:
> line.  If you wish to be a reviewer, please email stable@kernel.org to
> add your name to the list.  If you want to be off the reviewer list,
> also email us.

Hi Greg:

I am just wondering that is there any rule for stable kernel version
release?

AFAIK, 2.6.x kernels are all stable release and 2.6.x.y is for stable
tree bug fixing and long term supporting. But I found 2.6.16.y got 49
version updating, it is more active than other stable release such as
2.6.17 and 2.6.19. It looks like 2.6.16 is a long-long term supporting
version and even number 2.6.x kernel is more active than odd number
2.6.x kernel.

You know for some customer's product, they want to use the stable and
long term support kernel instead to use the latest one. 

Could you please give us some idea about this regular?

Thanks
-Bryan Wu
