Return-Path: <linux-kernel-owner+w=401wt.eu-S1761439AbXISQru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761439AbXISQru (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 12:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755983AbXISQrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 12:47:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39204
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755687AbXISQrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 12:47:40 -0400
Date: Wed, 19 Sep 2007 09:47:24 -0700 (PDT)
Message-Id: <20070919.094724.78016587.davem@davemloft.net>
To: ossthema@de.ibm.com
Cc: netdev@vger.kernel.org, raisch@de.ibm.com, themann@de.ibm.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, meder@de.ibm.com,
       tklein@de.ibm.com
Subject: Re: [PATCH net-2.6.24] eHEA: poll function update for new NAPI
 scheme
From: David Miller <davem@davemloft.net>
In-Reply-To: <200709191740.30640.ossthema@de.ibm.com>
References: <200709191740.30640.ossthema@de.ibm.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan-Bernd Themann <ossthema@de.ibm.com>
Date: Wed, 19 Sep 2007 17:40:30 +0200

> Update of ehea_poll function to work with new NAPI scheme.
> 
> Signed-off-by: Jan-Bernd Themann <themann@de.ibm.com>

Applied, thanks.
