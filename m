Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441Ab0BLRzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 12:55:38 -0500
Received: from maila.microsoft.com ([131.107.115.212]:41435 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757344Ab0BLRzh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 12:55:37 -0500
From: Hank Janssen <hjanssen@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 1/1] Staging: hv: Add proper versioning to HV
 drivers-Corrected.
Thread-Topic: [PATCH 1/1] Staging: hv: Add proper versioning to HV
 drivers-Corrected.
Thread-Index: AQHKq25lALDhh7OqjU+sP1lX9F83gpHCFTwAgAClhTA=
Date: Fri, 12 Feb 2010 17:55:34 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C56212E88B0F@TK5EX14MBXC118.redmond.corp.microsoft.com>
References: <8AFC7968D54FB448A30D8F38F259C56212E883CB@TK5EX14MBXC118.redmond.corp.microsoft.com>
 <20100211233612.GB10315@suse.de>
In-Reply-To: <20100211233612.GB10315@suse.de>
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


> >
> >  drivers/staging/hv/VersionInfo.h |   22 +++++++++++++++++++---
> 
> You forgot a "---" between the signed-off-by and the diffstat.  If you
> use either git or quilt, it will get this correct automagically.  That
> infers you used something else, which is quite scary.  What are you
> using instead to create patches?
> 
> Don't worry, I can edit this by hand when I apply it, and will do so in
> a few days when I get to my "to-apply" queue, but in the future, please
> don't do this.
> 
> thanks,
> 
> greg k-h

This must have been the result of a cut/paste error on my side.

I use the following command for my diff   'git diff -M -u --stat'

Btw, it was my understanding that the -M flag allows tracking of renamed 
files as well as part of the diff output. (git mv) But my diff command 
does not report on those.  Am I doing something wrong?

Thanks,

Hank.

