Return-Path: <linux-kernel-owner+w=401wt.eu-S1756980AbZLIEsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980AbZLIEsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 23:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756862AbZLIEsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 23:48:12 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34356
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756844AbZLIEsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 23:48:11 -0500
Date: Tue, 08 Dec 2009 20:48:17 -0800 (PST)
Message-Id: <20091208.204817.16733102.davem@davemloft.net>
To: jie.yang@atheros.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next]atl1c:add pci map direction in atl1c_buffer
 flags
From: David Miller <davem@davemloft.net>
In-Reply-To: <12601762192681-git-send-email-jie.yang@atheros.com>
References: <12601762192681-git-send-email-jie.yang@atheros.com>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: <jie.yang@atheros.com>
Date: Mon, 7 Dec 2009 16:56:59 +0800

> From: Jie Yang <jie.yang@atheros.com>
> 
> add pci map direction in atl1c_buffer flags, it is used when call pci_unmap 
> apis.
> Signed-off-by: Jie Yang <jie.yang@atheros.com>

Applied.
