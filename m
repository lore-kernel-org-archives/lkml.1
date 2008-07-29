Return-Path: <linux-kernel-owner+w=401wt.eu-S1759374AbYG2N7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759374AbYG2N7j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 09:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757988AbYG2N73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 09:59:29 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38094 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755299AbYG2N72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 09:59:28 -0400
Date: Tue, 29 Jul 2008 09:59:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Alexander Beregalov <a.beregalov@gmail.com>
cc: gregkh@suse.de, <linux-usb@vger.kernel.org>,
       <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb/core/driver: fix warning
In-Reply-To: <20080729015431.GA28952@orion>
Message-ID: <Pine.LNX.4.44L0.0807290959010.2518-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2008, Alexander Beregalov wrote:

> From: Alexander Beregalov <a.beregalov@gmail.com>
> 
> usb/core/driver: fix warning:
> drivers/usb/core/driver.c:834: warning: 'do_unbind_rebind' defined but not used
> 
> 
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>

Acked-by: Alan Stern <stern@rowland.harvard.edu>

