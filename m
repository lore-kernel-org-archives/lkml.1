Return-Path: <linux-kernel-owner+w=401wt.eu-S1752789AbXJWL15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbXJWL15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 07:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbXJWL1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 07:27:50 -0400
Received: from emerald.lightlink.com ([205.232.34.14]:3031 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbXJWL1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 07:27:50 -0400
Date: Tue, 23 Oct 2007 07:23:07 -0400
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [PATCH v2] ibmpex: Change printk to dev_{info,err} macros
Message-ID: <20071023112307.GB30546@jupiter.solarsys.private>
References: <20071017192902.GB3778@stusta.de> <20071017225850.7d8a9e88@hyperion.delvare> <20071017221503.GC31309@tree.beaverton.ibm.com> <20071019105402.546da123@hyperion.delvare> <20071019233507.GI31309@tree.beaverton.ibm.com> <20071020233052.19e7ffbf@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071020233052.19e7ffbf@hyperion.delvare>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi:

* Jean Delvare <khali@linux-fr.org> [2007-10-20 23:30:52 +0200]:
> On Fri, 19 Oct 2007 16:35:07 -0700, Darrick J. Wong wrote:
> > Ok, I'll change the message to be a bit more accurate.
> > ---
> > Clean up printk use in ibmpex.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> > ---
> 
> Acked-by: Jean Delvare <khali@linux-fr.org>

Applied to hwmon-2.6.git/testing, thanks.

-- 
Mark M. Hoffman
mhoffman@lightlink.com

