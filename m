Return-Path: <linux-kernel-owner+w=401wt.eu-S1755438AbZKNRCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438AbZKNRCp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 12:02:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754861AbZKNRCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 12:02:44 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38769
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753743AbZKNRCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 12:02:44 -0500
Date: Sat, 14 Nov 2009 09:03:00 -0800 (PST)
Message-Id: <20091114.090300.193720039.davem@davemloft.net>
To: acme@infradead.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, rth@twiddle.net,
       ink@jurassic.park.msu.ru
Subject: Re: [PATCH 1/1] alpha: Fixup recvmmsg syscall glue
From: David Miller <davem@davemloft.net>
In-Reply-To: <1258207434-5946-1-git-send-email-acme@infradead.org>
References: <1258207434-5946-1-git-send-email-acme@infradead.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@infradead.org>
Date: Sat, 14 Nov 2009 12:03:54 -0200

> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Richard Henderson <rth@twiddle.net>
> Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

Applied to net-next-2.6, thanks!
