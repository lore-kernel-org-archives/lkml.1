Return-Path: <linux-kernel-owner+w=401wt.eu-S1751964AbXAVUPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964AbXAVUPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 15:15:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbXAVUPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 15:15:42 -0500
Received: from coyote.holtmann.net ([217.160.111.169]:54538 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbXAVUPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 15:15:42 -0500
Subject: Re: [linux-usb-devel] [GIT PATCH] USB fixes for 2.6.20-rc5
From: Marcel Holtmann <marcel@holtmann.org>
To: Greg KH <gregkh@suse.de>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
In-Reply-To: <20070122200746.GA9936@kroah.com>
References: <20070122200746.GA9936@kroah.com>
Content-Type: text/plain
Date: Mon, 22 Jan 2007 21:15:04 +0100
Message-Id: <1169496904.27023.11.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

> They include a small number of fixes for some USB bugs, and some new
> device ids, all of the details are below.  I've also disabled the USB
> multithreaded probe option, as it broke a number of people's machines.

what about the two pending patches to make device_move() working as
expected. The current implementation is broken and basically useless.

Regards

Marcel


