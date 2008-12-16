Return-Path: <linux-kernel-owner+w=401wt.eu-S1753878AbYLPJSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbYLPJSI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 04:18:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbYLPJRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 04:17:48 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46790
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751225AbYLPJRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 04:17:47 -0500
Date: Tue, 16 Dec 2008 01:17:49 -0800 (PST)
Message-Id: <20081216.011749.124113130.davem@davemloft.net>
To: hannes@hanneseder.net
Cc: kkeil@suse.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] isdn: eicon: fix sparse warning: make global
 functions static
From: David Miller <davem@davemloft.net>
In-Reply-To: <49463d0c.09c5660a.36f7.ffffc710@mx.google.com>
References: <49463d0c.09c5660a.36f7.ffffc710@mx.google.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>
Date: Thu, 11 Dec 2008 17:59:14 +0100

> Fix this sparse warnings by making the functions static:
 ...
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>

Applied, thanks Hannes.
