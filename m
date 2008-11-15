Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbYKOE3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbYKOE3F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 23:29:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbYKOE2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 23:28:54 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37043 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbYKOE2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 23:28:53 -0500
Date: Sat, 15 Nov 2008 13:28:11 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, harvey.harrison@gmail.com, sfrench@us.ibm.com
Subject: Re: mmotm 2008-11-14-17-14 uploaded
Message-Id: <20081115132811.f04ef8e1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200811150115.mAF1FDpD010853@imap1.linux-foundation.org>
References: <200811150115.mAF1FDpD010853@imap1.linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2008 17:15:12 -0800
akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2008-11-14-17-14 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> It contains the following patches against 2.6.28-rc4:
> 

shows
  MODPOST 771 modules
ERROR: "global_cifs_sock_list" [fs/cifs/cifs.ko] undefined!
make[1]: *** [__modpost] Error 1

Maybe this ?
patches/cifs-remove-global_extern-macro.patch

Thanks,
-Kame

