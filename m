Return-Path: <linux-kernel-owner+w=401wt.eu-S1756416AbZEJVer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416AbZEJVer (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 17:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752437AbZEJVei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 17:34:38 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:50905 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbZEJVeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 17:34:37 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4A074855.8070008@s5r6.in-berlin.de>
Date: Sun, 10 May 2009 23:34:13 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090411 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Jeff Mahoney <jeffm@suse.com>
CC: Al Viro <viro@ftp.linux.org.uk>, reiserfs-devel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/4] reiserfs xattr fixups
References: <20090510200535.893737918@suse.com>
In-Reply-To: <20090510200535.893737918@suse.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Mahoney wrote:
>  Here are my remaining patches for reiserfs in 2.6.30:
> 
>  - reiserfs-xattr-fixup: Cleans up some ifdefs
>  - reiserfs-xattr-root-fixup: Fixes an oops on open_xa_dir with
> 			      CONFIG_REISERFS_FS_XATTR=n
>  - reiserfs-xattrs-disabled-perms: Fixes warnings on delete with
> 			      CONFIG_REISERFS_FS_XATTR=n (bko#13122)
>  - reiserfs-expose-privroot: Adds a -oexpose_privroot that will allow
> 			     access to the privroot.

I rebooted into v2.6.30-rc5-96-ga4d7749 + these four patches now.
Looks good so far.
-- 
Stefan Richter
-=====-=-=== -=-= -==-=
http://arcgraph.de/sr/
