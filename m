Return-Path: <linux-kernel-owner+w=401wt.eu-S1752144AbZISSFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbZISSFv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 14:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbZISSFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 14:05:51 -0400
Received: from smtp.wp.pl ([212.77.101.1]:58865 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751770AbZISSFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 14:05:50 -0400
Date: Sat, 19 Sep 2009 21:33:16 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       scst-devel <scst-devel@lists.sourceforge.net>
Subject: Re: [Scst-devel] [ANNOUNCE]: Support of QLogic Fibre Channel 4/8Gb
	(24xx/25xx) HBA's added in target driver for SCST qla2x00t
Message-ID: <20090919193315.GA2168@r2bh72.net.upc.cz>
References: <4AB29974.70602@vlnb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB29974.70602@vlnb.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [kbIk]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18, 2009 at 12:17:56AM +0400, Vladislav Bolkhovitin wrote:
> Although there is a current QLogic target driver qla_isp, this driver 
> has the key advantage that it was designed to be as simple as possible. 
> As the result, this driver is a lot smaller, cleaner and mainline Linux 
> kernel ready. After some cosmetic cleanups it's going to be pushed for 
> the in-kernel inclusion together other SCST patches.

Great, this makes qla_isp obsolete. I'm very happy with that, I guess
Matthew too.

Cheers
Stanislaw
