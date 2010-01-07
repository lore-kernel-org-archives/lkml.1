Return-Path: <linux-kernel-owner+w=401wt.eu-S1754781Ab0AGG3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab0AGG3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 01:29:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849Ab0AGG3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 01:29:16 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:56862 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab0AGG3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 01:29:16 -0500
MIME-Version: 1.0
In-Reply-To: <20100107095714.9edc4201.nishimura@mxp.nes.nec.co.jp>
References: <201001062259.o06MxQrp023236@imap1.linux-foundation.org>
	 <20100107095714.9edc4201.nishimura@mxp.nes.nec.co.jp>
Date: Thu, 7 Jan 2010 08:29:14 +0200
Message-ID: <cc557aab1001062229i3e8aec35ucb21f5acf2932ea9@mail.gmail.com>
Subject: Re: [PATCH -mmotm] memcg: implement memory thresholds document fixes
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 7, 2010 at 2:57 AM, Daisuke Nishimura
<nishimura@mxp.nes.nec.co.jp> wrote:
> Each memcg-implement-memory-thresholds.patch and
> memcg-add-interface-to-move-charge-at-task-migration.patch try to add a new
> section to Documentation/cgroup/memory.txt, so the document has been a bit
> mangled when these patches are merged at the same time.
>
> This patch fixes it.

Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
