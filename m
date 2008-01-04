Return-Path: <linux-kernel-owner+w=401wt.eu-S1752849AbYADLmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbYADLmw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 06:42:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbYADLmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 06:42:46 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44031
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751152AbYADLmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 06:42:45 -0500
Date: Fri, 04 Jan 2008 03:42:44 -0800 (PST)
Message-Id: <20080104.034244.108154232.davem@davemloft.net>
To: matthias@goebl.net
Cc: linux-kernel@vger.kernel.org, kkeil@suse.de, kai.germaschewski@gmx.de
Subject: Re: [PATCH] isdn/i4l: Fix DLE handling for i4l-audio
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080104104228.GX19071@night.goebl.net>
References: <20080103220003.GU19071@night.goebl.net>
	<20080104.021437.238302886.davem@davemloft.net>
	<20080104104228.GX19071@night.goebl.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthias Goebl <matthias@goebl.net>
Date: Fri, 4 Jan 2008 11:42:28 +0100

> But this does not care about a DLE and doesn't escape that with another DLE.

Now I understand, thank you.

I'll apply your patch.
