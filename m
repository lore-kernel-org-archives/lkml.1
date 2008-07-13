Return-Path: <linux-kernel-owner+w=401wt.eu-S1755921AbYGMTwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921AbYGMTwo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 15:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754649AbYGMTwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 15:52:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37628
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752564AbYGMTwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 15:52:35 -0400
Date: Sun, 13 Jul 2008 12:52:35 -0700 (PDT)
Message-Id: <20080713.125235.242090422.davem@davemloft.net>
To: olsajiri@gmail.com
Cc: tgraf@suug.ch, johannes@sipsolutions.net, linux-kernel@vger.kernel.org
Subject: Re: genetlink: genl_unregister_mc_group
From: David Miller <davem@davemloft.net>
In-Reply-To: <487A53C1.5000308@gmail.com>
References: <4878D9D3.1020109@gmail.com>
	<20080712.135031.193694627.davem@davemloft.net>
	<487A53C1.5000308@gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <olsajiri@gmail.com>
Date: Sun, 13 Jul 2008 21:13:05 +0200

> I'd like to dynamically add and remove multicast groups in my module,
> and I'd like to use a genetlink...

When you merge your module upstream, we'll add the export.

