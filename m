Return-Path: <linux-kernel-owner+w=401wt.eu-S1756262AbZFSHZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbZFSHZs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 03:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753973AbZFSHZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 03:25:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50169
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753194AbZFSHZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 03:25:36 -0400
Date: Fri, 19 Jun 2009 00:25:40 -0700 (PDT)
Message-Id: <20090619.002540.32287277.davem@davemloft.net>
To: dbaryshkov@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, slapin@ossfans.org
Subject: Re: [PATCH 1/2] ieee802154: use standard routine for printing dumps
From: David Miller <davem@davemloft.net>
In-Reply-To: <1245334607-16046-2-git-send-email-dbaryshkov@gmail.com>
References: <1245334607-16046-1-git-send-email-dbaryshkov@gmail.com>
	<1245334607-16046-2-git-send-email-dbaryshkov@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Date: Thu, 18 Jun 2009 18:16:46 +0400

> Use print_hex_dump_bytes instead of self-written dumping function
> for outputting packet dumps.
> 
> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>

Applied.
