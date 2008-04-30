Return-Path: <linux-kernel-owner+w=401wt.eu-S1757463AbYD3FjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463AbYD3FjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 01:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753169AbYD3Fi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 01:38:56 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55599
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753063AbYD3Fiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 01:38:55 -0400
Date: Tue, 29 Apr 2008 22:38:54 -0700 (PDT)
Message-Id: <20080429.223854.24800777.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: greg@kroah.com, sfr@canb.auug.org.au, jbarnes@virtuousgeek.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: gregkh-02-pci tree is now gone
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080429223412.0e8f135d.akpm@linux-foundation.org>
References: <20080424225104.GA16529@kroah.com>
	<20080429223412.0e8f135d.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 29 Apr 2008 22:34:12 -0700

> What is gregkh-03-ldp?

That's the special tree that breaks the linux-next build every day
in order to make sure Stephen is paying attention :-)
