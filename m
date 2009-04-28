Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbZD1Iyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbZD1Iyd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 04:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753473AbZD1IyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 04:54:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37598
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753080AbZD1IyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 04:54:17 -0400
Date: Tue, 28 Apr 2009 01:54:11 -0700 (PDT)
Message-Id: <20090428.015411.167936727.davem@davemloft.net>
To: jie.yang@atheros.com
Cc: bjoern.kiefer@gmail.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] atl1c: disable L1/L0s when link detected
From: David Miller <davem@davemloft.net>
In-Reply-To: <1240897323258-git-send-email-jie.yang@atheros.com>
References: <1240897323258-git-send-email-jie.yang@atheros.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: <jie.yang@atheros.com>
Date: Tue, 28 Apr 2009 13:42:03 +0800

> Disable L1/L0s when link detected. We enable L1/L0s when link connected
> before, but there is some hareware error on some platform. So just diable
> this feature when link connected. This feature is about power saving.
> 
> Signed-off-by: Jie Yang <jie.yang@atheros.com>

Applied.
