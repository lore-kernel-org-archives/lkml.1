Return-Path: <linux-kernel-owner+w=401wt.eu-S932740Ab0AGJFD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740Ab0AGJFD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 04:05:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932558Ab0AGJFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 04:05:01 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41040
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932469Ab0AGJE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 04:04:58 -0500
Date: Thu, 07 Jan 2010 01:05:06 -0800 (PST)
Message-Id: <20100107.010506.165517428.davem@davemloft.net>
To: jcliburn@gmail.com
Cc: jslaby@suse.cz, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       chris.snook@gmail.com, jie.yang@atheros.com,
       atl1-devel@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] NET: atlx, fix memory leak
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100106182830.4bd861fe@gmail.com>
References: <1262796856-21919-1-git-send-email-jslaby@suse.cz>
	<20100106182830.4bd861fe@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J K Cliburn <jcliburn@gmail.com>
Date: Wed, 6 Jan 2010 18:28:30 -0600

> On Wed,  6 Jan 2010 17:54:16 +0100
> Jiri Slaby <jslaby@suse.cz> wrote:
> 
>> Stanse found a memory leak in atl2_get_eeprom. eeprom_buff is not
>> freed/assigned on all paths. Fix that.
> 
> Acked by: Jay Cliburn <jcliburn@gmail.com>

Applied, thanks.
