Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343Ab0BQVme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 16:42:34 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57262
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757293Ab0BQVmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 16:42:31 -0500
Date: Wed, 17 Feb 2010 13:42:47 -0800 (PST)
Message-Id: <20100217.134247.169742000.davem@davemloft.net>
To: steve@digidescorp.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ll_temac: Add support for V2 LLTEMAC core
From: David Miller <davem@davemloft.net>
In-Reply-To: <1266426860-5634-1-git-send-email-steve@digidescorp.com>
References: <1266426860-5634-1-git-send-email-steve@digidescorp.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven J. Magnani" <steve@digidescorp.com>
Date: Wed, 17 Feb 2010 11:14:20 -0600

> LLTEMAC V1 cores place only received packet length in the app4 word.
> V2 cores place additional information in app4.
> Mask out the additional information when retrieving the packet length.
> 
> Signed-off-by: Steven J. Magnani <steve@digidescorp.com>

Applied.
