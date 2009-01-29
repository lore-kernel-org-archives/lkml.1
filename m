Return-Path: <linux-kernel-owner+w=401wt.eu-S1758708AbZA2Dpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708AbZA2Dpv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 22:45:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753678AbZA2Dpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 22:45:41 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:58182 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbZA2Dpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 22:45:40 -0500
Message-ID: <49812646.306@oracle.com>
Date: Wed, 28 Jan 2009 19:45:10 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org,
       phillip@lougher.demon.co.uk, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Documentation/Changes: add required versions for new
 filesystems
References: <1233158441-5475-1-git-send-email-notting@redhat.com> <20090128160157.GA5598@nostromo.devel.redhat.com> <20090128211347.GG8990@mit.edu>
In-Reply-To: <20090128211347.GG8990@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.49812649.01A5:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Wed, Jan 28, 2009 at 11:01:57AM -0500, Bill Nottingham wrote:
>> Bill Nottingham (notting@redhat.com) said: 
>>> btrfs requires version 0.18 of its tools, and squashfs requires
>>> 4.0.
>> This time, with a typo fix.
> 
> While you're at it, could you also update e2fsprogs to require 1.41.4.
> It's required for ext4, and even for ext3, if the text is going to
> say, "if you're going to report any bugs, please update to the
> versions of these programs".  So the line for e2fsprogs should read:
> 
>  o  e2fsprogs              1.41.4                    # e2fsck -V
> 
> I could push this as a separate patch, but then there could be patch
> conflicts, so it might be nice if you could update e2fsprogs at the
> same time.

I've done that and can add it to my Docs patches queue for Linus.

Thanks,
-- 
~Randy
