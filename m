Return-Path: <linux-kernel-owner+w=401wt.eu-S1756825AbZJ3AjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825AbZJ3AjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 20:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755691AbZJ3AjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 20:39:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55782
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755167AbZJ3AjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 20:39:16 -0400
Date: Thu, 29 Oct 2009 17:39:40 -0700 (PDT)
Message-Id: <20091029.173940.14401551.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: hancockrwd@gmail.com, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH] ide: update Kconfig text to mark as deprecated
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091030003337.57b712e7@lxorguk.ukuu.org.uk>
References: <51f3faa70910291719kecb5edcp3b8812981b69acb1@mail.gmail.com>
	<20091029.173028.248393897.davem@davemloft.net>
	<20091030003337.57b712e7@lxorguk.ukuu.org.uk>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Fri, 30 Oct 2009 00:33:37 +0000

> Then keep old IDE until the hardware rots. Its not worth contaminating
> libata and the scsi core with magic glue that only Dave Miller uses ;)

Fair enough :-)
