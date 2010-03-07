Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab0CGVKG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 16:10:06 -0500
Received: from senator.holtmann.net ([87.106.208.187]:57786 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab0CGVKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 16:10:04 -0500
Subject: Re: [PATCH] Bluetooth: fix coding style issue in hci_vhci.c This
 patch affects hci_vhci.c it fixes some warnings detected by the
 checkpath.pl tool Signed-off-by: Tiago Henriques <t.a.c.henriques@gmail.com>
From: Marcel Holtmann <marcel@holtmann.org>
To: Greg KH <gregkh@suse.de>
Cc: t.a.c.henriques@googlemail.com, t.a.c.henriques@gmail.com,
       adobriyan@gmail.com, tglx@linutronix.de,
       linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100307155658.GB1805@suse.de>
References: <1267934631-3531-1-git-send-email-t.a.c.henriques@gmail.com>
	 <20100307155658.GB1805@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 07 Mar 2010 13:08:12 -0800
Message-ID: <1267996092.3712.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tiago,

> Your Subject line is a bit messed up :)
> 
> You need to put extra lines in your git commit so that git-send-email
> doesn't barf on it.
> 
> On Sun, Mar 07, 2010 at 04:03:51AM +0000, t.a.c.henriques@googlemail.com wrote:
> > From: root <root@balganUbuntuVM.(none)>
> 
> And this is incorrect.

and this goes only to linux-bluetooth@vger.kernel.org. I really have no
idea why anybody else is on CC here. It is pure Bluetooth cleanup patch.

Regards

Marcel


