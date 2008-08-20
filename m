Return-Path: <linux-kernel-owner+w=401wt.eu-S1755877AbYHTSx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877AbYHTSx7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 14:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753897AbYHTSxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 14:53:49 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48150 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752726AbYHTSxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 14:53:48 -0400
Date: Wed, 20 Aug 2008 14:53:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Frank Peters <frank.peters@comcast.net>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.26 Breaks USB Fax Modem
In-Reply-To: <20080820120611.a528bd3d.frank.peters@comcast.net>
Message-ID: <Pine.LNX.4.44L0.0808201450540.14505-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2008, Frank Peters wrote:

> > This is completely new. Please compile 2.6.26 with CONFIG_USB_DEBUG
> > and reexamine the log. It should be more verbose.

> If I immediately reboot the machine with kernel 2.6.25, the same fax
> can be sent to the same fax machine with no problem.

If all else fails, you could try bisecting the kernels between
2.6.25 and 2.6.26 to locate the problem.

Alan Stern

