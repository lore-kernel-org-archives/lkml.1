Return-Path: <linux-kernel-owner+w=401wt.eu-S1757884AbZAOPPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884AbZAOPPG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 10:15:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754091AbZAOPOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 10:14:54 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:47678 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754087AbZAOPOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 10:14:53 -0500
Date: Thu, 15 Jan 2009 10:14:52 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: =?windows-1252?Q?Jir=28=ED_Burda?= <jburda@email.cz>
cc: Andrew Morton <akpm@linux-foundation.org>, <linux-usb@vger.kernel.org>,
       <greg@kroah.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: Nokia 5310 mass-storage not mounting in kernel
 2.6.28
In-Reply-To: <496E74B6.6080606@email.cz>
Message-ID: <Pine.LNX.4.44L0.0901151014270.2490-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2009, [windows-1252] Jir(í Burda wrote:

> Alan,
> 
> I can confirm Nokia 5310 with firmware 8.32 mounts correctly in 2.6.29-rc1.

Thanks for testing.  So your patch will be needed only for 
2.6.28.stable and earlier kernels.

Alan Stern

