Return-Path: <linux-kernel-owner+w=401wt.eu-S1754848AbYLVTHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbYLVTHW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 14:07:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbYLVTHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 14:07:09 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:42680 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbYLVTHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 14:07:08 -0500
Date: Mon, 22 Dec 2008 11:06:33 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Nick Andrew <nick@nick-andrew.net>
Cc: Roman Zippel <zippel@linux-m68k.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix incorrect use of loose in hfs.txt
Message-Id: <20081222110633.ea77cad9.randy.dunlap@oracle.com>
In-Reply-To: <20081205030758.31888.30272.stgit@marcab.local.tull.net>
References: <20081205030758.31888.30272.stgit@marcab.local.tull.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020A.494FE540.0295:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Dec 2008 14:07:58 +1100 Nick Andrew wrote:

> Fix incorrect use of loose in hfs.txt
> 
> It should be 'lose', not 'loose'.
> 
> Signed-off-by: Nick Andrew <nick@nick-andrew.net>
> ---

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Nick,
For any of these patches that were not picked up/merged/applied by someone,
maybe you should resend them to lkml/wherever and cc: trivial@kernel.org:


TRIVIAL PATCHES
P:	Jiri Kosina
M:	trivial@kernel.org
L:	linux-kernel@vger.kernel.org
T:	git kernel.org:/pub/scm/linux/kernel/git/jikos/trivial.git
S:	Maintained


>  Documentation/filesystems/hfs.txt |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/Documentation/filesystems/hfs.txt b/Documentation/filesystems/hfs.txt
> index bd0fa77..28f0225 100644
> --- a/Documentation/filesystems/hfs.txt
> +++ b/Documentation/filesystems/hfs.txt
> @@ -61,7 +61,7 @@ the a little strange:
>     Finder's metadata.
>   o They are however created (with default values), deleted and renamed
>     along with the corresponding data fork or directory.
> - o Copying files to a different filesystem will loose those attributes
> + o Copying files to a different filesystem will lose those attributes
>     that are essential for MacOS to work.
>  
>  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


---
~Randy
