Return-Path: <linux-kernel-owner+w=401wt.eu-S1759034AbYDCOH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759034AbYDCOH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 10:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757094AbYDCOHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 10:07:15 -0400
Received: from smtp21.orange.fr ([80.12.242.46]:44845 "EHLO smtp21.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755109AbYDCOHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 10:07:14 -0400
X-ME-UUID: 20080403140712224.36D221C000AC@mwinf2103.orange.fr
Subject: Re: ASUS ScreenDuo
From: Xavier Bestel <xavier.bestel@free.fr>
To: Mark Lord <lkml@rtr.ca>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <47F4E234.9000308@rtr.ca>
References: <1207230481.24037.11.camel@skunk.anacadf.mentorg.com>
	 <47F4E234.9000308@rtr.ca>
Content-Type: text/plain
Date: Thu, 03 Apr 2008 16:07:08 +0200
Message-Id: <1207231628.3438.6.camel@skunk.anacadf.mentorg.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-04-03 at 09:57 -0400, Mark Lord wrote:
> > [root@awak:~]$ fdisk /dev/sdc
> > 
> > Unable to open /dev/sdc
> > 
> ..
> 
> As root, try:   mknod /tmp/sdc b 8 32 ; fdisk /tmp/sdc
> 
> Any different? 

Nope. But /dev/sdc has already been created, and looks right (b 8 32
too). Just there's nothing behind it.

	Xav


