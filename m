Return-Path: <linux-kernel-owner+w=401wt.eu-S1756503AbZLUDII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503AbZLUDII (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 22:08:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756358AbZLUDIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 22:08:07 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:34889 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755662AbZLUDIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 22:08:05 -0500
Date: Mon, 21 Dec 2009 12:07:50 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mhiramat@redhat.com, dhowells@redhat.com
Subject: Re: [PATCH] elf_fdpic_core_dump(): fix build break in 2.6.33-rc1
Message-ID: <20091221030749.GA15721@linux-sh.org>
References: <20091221.110431.189715673.d.hatayama@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091221.110431.189715673.d.hatayama@jp.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 21, 2009 at 11:04:31AM +0900, Daisuke HATAYAMA wrote:
> The commit f6151dfea21496d43dbaba32cfcd9c9f404769bc causes build
> break, so this patch fixes it together with the correction for printk
> format.
> 
> Thanks.
> 
> Signed-off-by: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>

I was about to send the same patch.. :-)

Acked-by: Paul Mundt <lethal@linux-sh.org>
