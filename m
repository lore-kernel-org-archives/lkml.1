Return-Path: <linux-kernel-owner+w=401wt.eu-S1755251AbZEMFNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbZEMFNv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 01:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751051AbZEMFNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 01:13:42 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48363
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750843AbZEMFNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 01:13:42 -0400
Date: Tue, 12 May 2009 22:13:38 -0700 (PDT)
Message-Id: <20090512.221338.72071721.davem@davemloft.net>
To: seto.hidetoshi@jp.fujitsu.com
Cc: matthew@wil.cx, jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI MSI: Yet another fix for MSI-X with NIU cards
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A0A4829.8080709@jp.fujitsu.com>
References: <20090508131333.GV8112@parisc-linux.org>
	<4A0A4829.8080709@jp.fujitsu.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Date: Wed, 13 May 2009 13:10:17 +0900

> Could you review & test following patch for your issue?

I cannot test until Saturday as I am on a cruise.
