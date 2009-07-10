Return-Path: <linux-kernel-owner+w=401wt.eu-S1752915AbZGJDRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915AbZGJDRT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 23:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbZGJDRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 23:17:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39310
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750835AbZGJDRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 23:17:06 -0400
Date: Thu, 09 Jul 2009 20:17:08 -0700 (PDT)
Message-Id: <20090709.201708.99486657.davem@davemloft.net>
To: davej@redhat.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org
Subject: Re: Fix compile error in bmac.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090710015439.GA28864@redhat.com>
References: <20090710015439.GA28864@redhat.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Jones <davej@redhat.com>
Date: Thu, 9 Jul 2009 21:54:39 -0400

> Looks like the change in ad361c9884e809340f6daca80d56a9e9c871690a
> wasn't compile tested.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>

Acked-by: David S. Miller <davem@davemloft.net>
