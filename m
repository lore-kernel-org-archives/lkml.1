Return-Path: <linux-kernel-owner+w=401wt.eu-S1752315AbYIDGxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315AbYIDGxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 02:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751100AbYIDGxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 02:53:05 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:26299 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbYIDGxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 02:53:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=gU3RLVsI1V9VZgyl9d/bVziu+jUhd2qtSQ71DoKwKLHFl2c2/H0GdluiOG177sqh0o
         sPZ0D6giMXzy3qMz+p3Ld2cMBgLsUhAHtuzcBvd2jO+s3MQIgRKSrWBOB72bnBC1ZdV3
         gyPcXgemzCKA84sbjwVW56L5tL1/wcL8bmVRQ=
Message-ID: <48BF85C7.5050401@gmail.com>
Date: Thu, 04 Sep 2008 08:52:55 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, jkosina@suse.cz,
       akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] hid: fix gyration build error
References: <20080903191619.6b6b230e.sfr@canb.auug.org.au> <20080903193218.d79e0f1a.randy.dunlap@oracle.com>
In-Reply-To: <20080903193218.d79e0f1a.randy.dunlap@oracle.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2008 04:32 AM, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix config symbol name in ifdef to fix build error:
> 
> ERROR: "hid_compat_gyration" [drivers/hid/hid-dummy.ko] undefined!
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> cc: Jiri Kosina <jkosina@suse.cz>

Acked-by: Jiri Slaby <jirislaby@gmail.com>

Thanks for catching this. My cut&paste typo.
