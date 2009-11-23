Return-Path: <linux-kernel-owner+w=401wt.eu-S1755776AbZKWJSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776AbZKWJSF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 04:18:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755043AbZKWJSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 04:18:04 -0500
Received: from zbasel.fortytwo.ch ([193.138.215.60]:50533 "EHLO
	zbasel.fortytwo.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548AbZKWJSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 04:18:03 -0500
From: Adrian von Bidder <avbidder@fortytwo.ch>
To: Peter Feuerer <peter@piie.net>
Subject: Re: acerhdf: stilll fighting between kernel and BIOS?
Date: Mon, 23 Nov 2009 10:17:59 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-1-686; KDE/4.3.2; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <200911200823.58897@fortytwo.ch> <cone.1258925270.277361.2967.1000@deskpiie>
In-Reply-To: <cone.1258925270.277361.2967.1000@deskpiie>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911231018.00163@fortytwo.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heyho!

On Sunday 22 November 2009 22.27:50 Peter Feuerer wrote:
> issues with AOA 150 netbooks should be solved with current 2.6.32-git
>  tree. You can also try to use latest acerhdf of http://piie.net

Seems to work fine.  That was the fix I thought was already included in 
2.6.31.

thanks a lot.

-- vbi

 
> > Nov 20 08:07:12 laeggerli kernel: [100246.224141] acerhdf: temp 51
> > Nov 20 08:07:12 laeggerli kernel: [100246.272136] acerhdf: fan OFF
> > Nov 20 08:07:22 laeggerli kernel: [100256.328145] acerhdf: temp 51
> > Nov 20 08:07:22 laeggerli kernel: [100256.376072] acerhdf: fan OFF


-- 
As flies to wanton boys are we to the gods; they kill us for their sport.
		-- Shakespeare, "King Lear"
