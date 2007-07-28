Return-Path: <linux-kernel-owner+w=401wt.eu-S1753768AbXG1PUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768AbXG1PUa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 11:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751582AbXG1PUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 11:20:18 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:21856 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbXG1PUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 11:20:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=P+kMO8FbxuX0inT8GCWOuPLCcT/b3l8cJ24OofDpccd0UWcHuXM8IjPkYhGSNF9iG0f2FUx78MOFGLOKZq2cOkyABEPdo4FH4CfH4Ghao8ObtegHorhZyhbgi7pJcLeCWeoz9flwZsoIK5GKa1EtHP5buAR+64bUcrRRFYdflms=
Message-ID: <46AB5DB9.2090106@googlemail.com>
Date: Sat, 28 Jul 2007 17:16:09 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: FUJITA Tomonori <tomof@acm.org>
CC: James.Bottomley@SteelEye.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org
Subject: Re: BSG: BLK_DEV_BSG=y , BLOCK=n compile error
References: <46AB3C6A.2070209@googlemail.com> <200707281446.l6SEkGOD003581@mbox.iij4u.or.jp>
In-Reply-To: <200707281446.l6SEkGOD003581@mbox.iij4u.or.jp>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> From: Gabriel C <nix.or.die@googlemail.com>
> Subject: BSG: BLK_DEV_BSG=y , BLOCK=n compile error
> Date: Sat, 28 Jul 2007 14:54:02 +0200
> 
>> Hi,
>>
>> BSG does not compile without BLOCK set :
> 
> Thanks, this has already been addressed.
> 
> http://marc.info/?l=linux-kernel&m=118534836402440&w=2
> 

Upss , sorry I didn't find that one is why I reported it.


Gabriel
