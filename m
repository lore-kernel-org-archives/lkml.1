Return-Path: <linux-kernel-owner+w=401wt.eu-S1754954AbZF2RzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbZF2RzE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 13:55:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752968AbZF2Ryx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 13:54:53 -0400
Received: from kroah.org ([198.145.64.141]:56649 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771AbZF2Ryw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 13:54:52 -0400
Date: Mon, 29 Jun 2009 10:52:13 -0700
From: Greg KH <greg@kroah.com>
To: Prabhu Chawandi <prabhu.chavandi@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: External USB mass storage device no detecting
Message-ID: <20090629175213.GA10526@kroah.com>
References: <241b8f7b0906282251x23fead6dobcb24cb639e9fdb0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <241b8f7b0906282251x23fead6dobcb24cb639e9fdb0@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 11:21:19AM +0530, Prabhu Chawandi wrote:
> Hi,
> 
>   I am having WD external mass storage device, which has Mini USB
> connector.  They have given the USB type A to mini converter.
> 
> I have set CONFIG_USB_STORAGE=y, after building 2.6.18-6.4 version and
> booting: I am connecting the device its not getting detected, while
> USB stics are getting
> 
> detected.
> 
> Am I missing any drivers ? Please suggest .

There is no such kernel.org release as "2.6.18-6.4", so you must be
using a vendor supplied kernel version.  I suggest contacting them for
support, as the 2.6.18 kernel was released a few _years_ and many
hundreds of thousands of changes ago.

good luck,

greg k-h
