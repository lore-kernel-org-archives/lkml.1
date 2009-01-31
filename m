Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbZAaIuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbZAaIuS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 03:50:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbZAaIuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 03:50:04 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45253
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750891AbZAaIuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 03:50:03 -0500
Date: Sat, 31 Jan 2009 00:50:00 -0800 (PST)
Message-Id: <20090131.005000.75318985.davem@davemloft.net>
To: sachinp@in.ibm.com
Cc: linuxppc-dev@ozlabs.org, yoshfuji@linux-ipv6.org,
       kamalesh@linux.vnet.ibm.com, mel@csn.ul.ie,
       linux-kernel@vger.kernel.org
Subject: Re: [Patch] 2.6.29-rc3-git2 - Fix net/ipv6/ip6mr.o build break
From: David Miller <davem@davemloft.net>
In-Reply-To: <4983EEE3.3080208@in.ibm.com>
References: <4983EEE3.3080208@in.ibm.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks for the report, Dave Jones already posted this fix
(CC:'d to the correct location, netdev@vger.kernel.org)
