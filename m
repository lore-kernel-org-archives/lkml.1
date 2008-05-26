Return-Path: <linux-kernel-owner+w=401wt.eu-S1756457AbYEZTdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457AbYEZTdz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 15:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755031AbYEZTdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 15:33:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55022
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755018AbYEZTdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 15:33:43 -0400
Date: Mon, 26 May 2008 12:33:38 -0700 (PDT)
Message-Id: <20080526.123338.161271834.davem@davemloft.net>
To: jesper@krogh.cc
Cc: yhlu.kernel@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: NIU - Sun Neptune 10g - Transmit timed out reset (2.6.24)
From: David Miller <davem@davemloft.net>
In-Reply-To: <483B0986.70606@krogh.cc>
References: <20080510.213431.193696750.davem@davemloft.net>
	<4827E930.3000008@krogh.cc>
	<483B0986.70606@krogh.cc>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Krogh <jesper@krogh.cc>
Date: Mon, 26 May 2008 21:03:34 +0200

> Ok. Now I also hit it in production with the NFS-server, so this
> is definately a real bug somewhere in the driver. Should I register it
> at bugzilla?

Please feel free to do that.
