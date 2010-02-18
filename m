Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546Ab0BRPvz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 10:51:55 -0500
Received: from mailb.microsoft.com ([131.107.115.215]:37868 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758529Ab0BRPvy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 10:51:54 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       Hank Janssen <hjanssen@microsoft.com>,
       "'gregkh@suse.de'" <gregkh@suse.de>
Subject: RE: [PATCH 1/1] Stage: hv: Rename struct device_context and
 re-arrange the fields inside (re-formatted)
Thread-Topic: [PATCH 1/1] Stage: hv: Rename struct device_context and
 re-arrange the fields inside (re-formatted)
Thread-Index: AQHKsBQAIqog4dWG9E+RbBAV2UnaG5HLfnSAgACFF5A=
Date: Thu, 18 Feb 2010 15:51:54 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF725A90D84E@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1FB5E1D5CA062146B38059374562DF725A908A11@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20100217235223.GG12197@kroah.com>
In-Reply-To: <20100217235223.GG12197@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Ok, I fixed the patch up, but it looks like you did not make this
> against the linux-next tree, but against Linus's tree, right?  The code
> has changed since Linus's tree a bit in places (dead code was removed),
> and it conflicted with this patch.
> 
> Next time please be more careful.

Thanks for fixing the patch! 
And, I will ensure I use linux-next tree for future patches.

- Haiyang
