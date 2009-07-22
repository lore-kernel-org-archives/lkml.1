Return-Path: <linux-kernel-owner+w=401wt.eu-S1753464AbZGVUcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464AbZGVUcJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 16:32:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbZGVUcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 16:32:09 -0400
Received: from mail.windriver.com ([147.11.1.11]:50100 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753323AbZGVUcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 16:32:07 -0400
Message-ID: <4A677722.2010203@windriver.com>
Date: Wed, 22 Jul 2009 15:31:30 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Wu Zhangjin <wuzhangjin@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       ralf@linux-mips.org, Wu Zhangjin <wuzj@lemote.com>,
       Yan Hua <yanh@lemote.com>, Philippe Vachon <philippe@cowpig.ca>,
       Zhang Le <r0bertz@gentoo.org>, Zhang Fuxin <zhangfx@lemote.com>,
       loongson-dev <loongson-dev@googlegroups.com>,
       Liu Junliang <liujl@lemote.com>, Erwan Lerale <erwan@thiscow.com>,
       Arnaud Patard <apatard@mandriva.com>
Subject: Re: [PATCH v4 02/16] [loongson] kgdb: Remove out-of-date board-specific
 source code
References: <cover.1246546684.git.wuzhangjin@gmail.com> <0e211b21ed263c482b3717e8feb9bd84e1a11839.1246546684.git.wuzhangjin@gmail.com>
In-Reply-To: <0e211b21ed263c482b3717e8feb9bd84e1a11839.1246546684.git.wuzhangjin@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Jul 2009 20:31:26.0931 (UTC) FILETIME=[6323B230:01CA0B0B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Zhangjin wrote:
> From: Wu Zhangjin <wuzj@lemote.com>
>
> as the commit: 8854700115ecf8aa6f087aa915b7b6cf18090d39 shows, the new
> mips-specific kgdb implementation not need this board-specific source
> code, just remove it.
>
> Signed-off-by: Wu Zhangjin <wuzj@lemote.com>
>   

That should be the last of the dbg_io.c files.

Looks good to me.

Acked-by: Jason Wessel <jason.wessel@windriver.com>

Thanks,
Jason.
