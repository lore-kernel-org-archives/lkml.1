Return-Path: <linux-kernel-owner+w=401wt.eu-S1757198AbYC1Axw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbYC1Axw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 20:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753811AbYC1Axj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 20:53:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50247
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753623AbYC1Axi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 20:53:38 -0400
Date: Thu, 27 Mar 2008 17:53:38 -0700 (PDT)
Message-Id: <20080327.175338.90156948.davem@davemloft.net>
To: ilpo.jarvinen@helsinki.fi
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, acme@redhat.com
Subject: Re: [PATCH 5/7] [NET]: uninline dst_release
From: David Miller <davem@davemloft.net>
In-Reply-To: <1206621486-5408-6-git-send-email-ilpo.jarvinen@helsinki.fi>
References: <1206621486-5408-4-git-send-email-ilpo.jarvinen@helsinki.fi>
	<1206621486-5408-5-git-send-email-ilpo.jarvinen@helsinki.fi>
	<1206621486-5408-6-git-send-email-ilpo.jarvinen@helsinki.fi>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ilpo_Järvinen" <ilpo.jarvinen@helsinki.fi>
Date: Thu, 27 Mar 2008 14:38:04 +0200

> Codiff stats (allyesconfig, v2.6.24-mm1):
> -16420  187 funcs, 103 +, 16523 -, diff: -16420 --- dst_release
> 
> Without number of debug related CONFIGs (v2.6.25-rc2-mm1):
> -7257  186 funcs, 70 +, 7327 -, diff: -7257 --- dst_release
> dst_release                   |  +40
> 
> Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>

Applied.
