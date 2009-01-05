Return-Path: <linux-kernel-owner+w=401wt.eu-S1752301AbZAEAGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301AbZAEAGW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 19:06:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840AbZAEAGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 19:06:09 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41359
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750788AbZAEAGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 19:06:08 -0500
Date: Sun, 04 Jan 2009 16:06:11 -0800 (PST)
Message-Id: <20090104.160611.252248503.davem@davemloft.net>
To: jeffrey.t.kirsher@intel.com
Cc: jaswinder@infradead.org, linux.nics@intel.com,
       e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [PATCH -net-next 1/4] firmware: convert e100 driver to
 request_firmware()
From: David Miller <davem@davemloft.net>
In-Reply-To: <9929d2390812301433pae01ea4g5bfdef6d4d4c7a9c@mail.gmail.com>
References: <1230626401.24796.22.camel@jaswinder.satnam>
	<9929d2390812301433pae01ea4g5bfdef6d4d4c7a9c@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>
Date: Tue, 30 Dec 2008 14:33:36 -0800

> Please hold off on committing, until we have had ample time to do some
> regression testing.  While this patch may have been in linux-next,
> this is the first we have seen of it.
> 
> I am concerned that IPMI traffic will be adversely affected by this patch.

Status please?
