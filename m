Return-Path: <linux-kernel-owner+w=401wt.eu-S1751757AbZKPFQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757AbZKPFQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 00:16:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751375AbZKPFQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 00:16:57 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58689
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751339AbZKPFQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 00:16:56 -0500
Date: Sun, 15 Nov 2009 21:17:12 -0800 (PST)
Message-Id: <20091115.211712.254217052.davem@davemloft.net>
To: stas@lvk.cs.msu.su
Cc: aabdulla@nvidia.com, yinghai@kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] forcedeth: mac address fix
From: David Miller <davem@davemloft.net>
In-Reply-To: <1258187485-11549-1-git-send-email-stas@lvk.cs.msu.su>
References: <1258187485-11549-1-git-send-email-stas@lvk.cs.msu.su>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Stanislav O\. Bezzubtsev" <stas@lvk.cs.msu.su>
Date: Sat, 14 Nov 2009 11:31:25 +0300

> Use the existing random_ether_addr() to generate random MAC
> instead of doing it by-hand.
> 
> Signed-off-by: Stanislav O. Bezzubtsev <stas@lvk.cs.msu.su>

Applied, thank you.
