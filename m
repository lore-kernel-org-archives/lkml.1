Return-Path: <linux-kernel-owner+w=401wt.eu-S1756945AbZJ3Abz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945AbZJ3Abz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 20:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756143AbZJ3Abz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 20:31:55 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56210 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755430AbZJ3Aby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 20:31:54 -0400
Date: Fri, 30 Oct 2009 00:33:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Miller <davem@davemloft.net>
Cc: hancockrwd@gmail.com, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH] ide: update Kconfig text to mark as deprecated
Message-ID: <20091030003337.57b712e7@lxorguk.ukuu.org.uk>
In-Reply-To: <20091029.173028.248393897.davem@davemloft.net>
References: <4AE64FCC.4030102@gmail.com>
	<20091029.031344.102288703.davem@davemloft.net>
	<51f3faa70910291719kecb5edcp3b8812981b69acb1@mail.gmail.com>
	<20091029.173028.248393897.davem@davemloft.net>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And I know I won't be the only person in this kind of situation.
> 
> So, proceeding in any other way is really a non-starter.

Then keep old IDE until the hardware rots. Its not worth contaminating
libata and the scsi core with magic glue that only Dave Miller uses ;)

Alan
