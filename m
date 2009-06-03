Return-Path: <linux-kernel-owner+w=401wt.eu-S1755258AbZFCDPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbZFCDPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 23:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbZFCDP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 23:15:27 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:42564 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722AbZFCDP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 23:15:27 -0400
Date: Wed, 3 Jun 2009 11:45:18 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: [PATCH mmotm 0/2] memcg: changes to *.limit_in_bytes
Message-Id: <20090603114518.301cef4d.nishimura@mxp.nes.nec.co.jp>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are patches that change the usage of *.limit_in_bytes files.

[1/2] memcg: add interface to reset limits
[2/2] memcg: allow mem.limit bigger than memsw.limit iff unlimited

They are based on mmotm-2009-06-02-16-11.

Any comments would be welcome.

Thanks,
Daisuke Nishimura.
