Return-Path: <linux-kernel-owner+w=401wt.eu-S1756207AbYEZWP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207AbYEZWP4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 18:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755415AbYEZWPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 18:15:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54841
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755413AbYEZWPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 18:15:44 -0400
Date: Mon, 26 May 2008 15:15:40 -0700 (PDT)
Message-Id: <20080526.151540.191673092.davem@davemloft.net>
To: jesper@krogh.cc
Cc: yhlu.kernel@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, matheos.worku@sun.com
Subject: Re: NIU - Sun Neptune 10g - Transmit timed out reset (2.6.24)
From: David Miller <davem@davemloft.net>
In-Reply-To: <483B239D.4090402@krogh.cc>
References: <20080526.123338.161271834.davem@davemloft.net>
	<20080526.123951.260448303.davem@davemloft.net>
	<483B239D.4090402@krogh.cc>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Krogh <jesper@krogh.cc>
Date: Mon, 26 May 2008 22:54:53 +0200

> Applied and running.. I've now pushed 400GB of data through it trying to
> get it to hit the bug but it is still running.
> 
> So without saying that it solved the problem, it definately seems so.
> 2.6.26-rc4 + above patch.

Thanks for testing.
