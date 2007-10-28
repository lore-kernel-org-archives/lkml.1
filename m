Return-Path: <linux-kernel-owner+w=401wt.eu-S1756876AbXJ1Rsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876AbXJ1Rsy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 13:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753931AbXJ1Rsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 13:48:45 -0400
Received: from emerald.lightlink.com ([205.232.34.14]:12434 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208AbXJ1Rso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 13:48:44 -0400
Date: Sun, 28 Oct 2007 13:48:20 -0400
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH] i5k_amb: Convert macros to C functions
Message-ID: <20071028174820.GO30546@jupiter.solarsys.private>
References: <20070730033840.GG31314@jupiter.solarsys.private> <20070730192606.GD2795@tree.beaverton.ibm.com> <200707302141.l6ULfAnT021069@e1.ny.us.ibm.com> <20070731183706.GG2795@tree.beaverton.ibm.com> <20071016125429.GG3731@jupiter.solarsys.private> <20071016230657.GA6408@tree.beaverton.ibm.com> <20071018131550.GA3526@jupiter.solarsys.private> <20071018202243.GF31309@tree.beaverton.ibm.com> <20071025161912.9e4ef550.akpm@linux-foundation.org> <20071026185511.GB7333@tree.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071026185511.GB7333@tree.beaverton.ibm.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi:

* Darrick J. Wong <djwong@us.ibm.com> [2007-10-26 11:55:11 -0700]:
> akpm objected to some of the macros, so convert them into functions.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
>  drivers/hwmon/i5k_amb.c |   65 +++++++++++++++++++++++++++++++----------------
>  1 files changed, 43 insertions(+), 22 deletions(-)

Applied to hwmon-2.6.git/testing, thanks.

-- 
Mark M. Hoffman
mhoffman@lightlink.com

