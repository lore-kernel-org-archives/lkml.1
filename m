Return-Path: <linux-kernel-owner+w=401wt.eu-S1760435AbYDBHDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760435AbYDBHDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 03:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757238AbYDBHDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 03:03:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47914
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755689AbYDBHDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 03:03:33 -0400
Date: Wed, 02 Apr 2008 00:03:34 -0700 (PDT)
Message-Id: <20080402.000334.14012482.davem@davemloft.net>
To: lpotenza@inwind.it
Cc: kernel-janitors@vger.kernel.org, chas@cmf.nrl.navy.mil,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/atm/iphase.c: compilation warning fix
From: David Miller <davem@davemloft.net>
In-Reply-To: <200804012349.29836.lpotenza@inwind.it>
References: <200804012349.29836.lpotenza@inwind.it>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Leonardo Potenza <lpotenza@inwind.it>
Date: Tue, 1 Apr 2008 23:49:29 +0200

> From: Leonardo Potenza <lpotenza@inwind.it>
> 
> Removed the warning messages:
> drivers/atm/iphase.c:961: warning: 'tcnter' defined but not used
> drivers/atm/iphase.c:963: warning: 'xdump' defined but not used
> 
> tcnter and xdump() are used only in debug build
> 
> Signed-off-by: Leonardo Potenza <lpotenza@inwind.it>

Applied, thanks.
