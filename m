Return-Path: <linux-kernel-owner+w=401wt.eu-S1752718AbXJWLJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbXJWLJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 07:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbXJWLJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 07:09:48 -0400
Received: from emerald.lightlink.com ([205.232.34.14]:31852 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbXJWLJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 07:09:47 -0400
Date: Tue, 23 Oct 2007 07:03:00 -0400
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: lm-sensors@lm-sensors.org, Jeff Garrett <jgarrett@teamhpc.com>,
       Vadim Zeitlin <vadim@zeitlins.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] i5k_amb: New memory temperature sensor driver
Message-ID: <20071023110300.GA30546@jupiter.solarsys.private>
References: <20070716202807.GD2619@tree.beaverton.ibm.com> <20070716221429.GF2619@tree.beaverton.ibm.com> <20070730033840.GG31314@jupiter.solarsys.private> <20070730192606.GD2795@tree.beaverton.ibm.com> <200707302141.l6ULfAnT021069@e1.ny.us.ibm.com> <20070731183706.GG2795@tree.beaverton.ibm.com> <20071016125429.GG3731@jupiter.solarsys.private> <20071016230657.GA6408@tree.beaverton.ibm.com> <20071018131550.GA3526@jupiter.solarsys.private> <20071018202243.GF31309@tree.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018202243.GF31309@tree.beaverton.ibm.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darrick:

* Darrick J. Wong <djwong@us.ibm.com> [2007-10-18 13:22:43 -0700]:
> New driver to read FB-DIMM temperature sensors on systems with the
> Intel 5000 series chipsets.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
>  drivers/hwmon/Kconfig   |   10 +
>  drivers/hwmon/Makefile  |    1 
>  drivers/hwmon/i5k_amb.c |  531 +++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/pci_ids.h |    3 
>  4 files changed, 545 insertions(+), 0 deletions(-)

Applied to hwmon-2.6.git/testing, thanks.

-- 
Mark M. Hoffman
mhoffman@lightlink.com

