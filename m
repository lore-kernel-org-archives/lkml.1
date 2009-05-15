Return-Path: <linux-kernel-owner+w=401wt.eu-S1755045AbZEOEgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbZEOEgt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 00:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbZEOEgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 00:36:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55630
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752431AbZEOEgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 00:36:39 -0400
Date: Thu, 14 May 2009 21:36:36 -0700 (PDT)
Message-Id: <20090514.213636.109200056.davem@davemloft.net>
To: teheo@novell.com
Cc: JBeulich@novell.com, andi@firstfloor.org, mingo@elte.hu,
       linux-kernel-owner@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] x86,percpu: fix pageattr handling with remap
 allocator
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A0CE8C6.4020102@novell.com>
References: <1242305390-21958-1-git-send-email-tj@kernel.org>
	<4A0C4528.90608@novell.com>
	<4A0CE8C6.4020102@novell.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


You might want to drop linux-kernel-owner from the CC:, I already
get enough copies :-)
