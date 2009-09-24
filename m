Return-Path: <linux-kernel-owner+w=401wt.eu-S1753449AbZIXVKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbZIXVKj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 17:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbZIXVKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 17:10:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51113
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753042AbZIXVKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 17:10:38 -0400
Date: Thu, 24 Sep 2009 14:10:56 -0700 (PDT)
Message-Id: <20090924.141056.03293772.davem@davemloft.net>
To: mathieu.desnoyers@polymtl.ca
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [patch 07/12] Sparc create asm.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090924133400.044916740@polymtl.ca>
References: <20090924132626.485545323@polymtl.ca>
	<20090924133400.044916740@polymtl.ca>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Date: Thu, 24 Sep 2009 09:26:33 -0400

> Create a assembly compatibility header for sparc32/64.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Acked-by: David S. Miller <davem@davemloft.net>
