Return-Path: <linux-kernel-owner+w=401wt.eu-S1755963AbZDBIKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbZDBIKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 04:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754145AbZDBIKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 04:10:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33802
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752713AbZDBIKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 04:10:13 -0400
Date: Thu, 02 Apr 2009 01:10:01 -0700 (PDT)
Message-Id: <20090402.011001.03958848.davem@davemloft.net>
To: Larry.Finger@lwfinger.net
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, oliver@neukum.org
Subject: Re: [PATCH 1/2 V3] kaweth: Fix locking to be SMP-safe
From: David Miller <davem@davemloft.net>
In-Reply-To: <49d3881d.7EinO6dA2s6BnVTa%Larry.Finger@lwfinger.net>
References: <49d3881d.7EinO6dA2s6BnVTa%Larry.Finger@lwfinger.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Wed, 01 Apr 2009 10:28:29 -0500

> On an SMP system, the following message is printed. The patch below gets
> fixes the problem.
 ...

> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
 ...
> I had expected this to be 2.6.31 material, but Oliver requested that it be
> sent to Stable as well.

Applied, thanks.
