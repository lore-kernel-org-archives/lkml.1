Return-Path: <linux-kernel-owner+w=401wt.eu-S1756081AbZLSEQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbZLSEQU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 23:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756039AbZLSEQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 23:16:19 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36589
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756027AbZLSEQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 23:16:18 -0500
Date: Fri, 18 Dec 2009 20:16:20 -0800 (PST)
Message-Id: <20091218.201620.28810836.davem@davemloft.net>
To: mcarlson@broadcom.com
Cc: roel.kluin@gmail.com, netdev@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] broadcom: bcm54xx_shadow_read() errors ignored in
 bcm54xx_adjust_rxrefclk()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091218014138.GA22080@xw6200.broadcom.net>
References: <4B28DA62.40909@gmail.com>
	<20091218014138.GA22080@xw6200.broadcom.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Matt Carlson" <mcarlson@broadcom.com>
Date: Thu, 17 Dec 2009 17:41:39 -0800

> On Wed, Dec 16, 2009 at 05:02:26AM -0800, Roel Kluin wrote:
>> If not signed read errors are ignored.
>> 
>> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> 
> Acked-by: Matt Carlson <mcarlson@broadcom.com>

Applied, thanks.
