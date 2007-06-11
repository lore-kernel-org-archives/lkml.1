Return-Path: <linux-kernel-owner+w=401wt.eu-S1755426AbXFKPEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426AbXFKPEL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 11:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754706AbXFKPCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 11:02:16 -0400
Received: from twin.jikos.cz ([213.151.79.26]:50768 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754526AbXFKPCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 11:02:13 -0400
Date: Mon, 11 Jun 2007 17:02:08 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Islam Amer <pharon@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: USB remote control missing keycodes
In-Reply-To: <1181563063.19258.11.camel@iamer-laptop>
Message-ID: <Pine.LNX.4.64.0706111656340.23280@twin.jikos.cz>
References: <20070611101319.GA14284@DervishD>  <466D2DF7.9020709@aladin.ro>
 <1181563063.19258.11.camel@iamer-laptop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jun 2007, Islam Amer wrote:

> I have a remote control device, with an IR transciever that plugs into a 
> USB port and registers as an input device. All the buttons on the remote 
> work fine except for the back , text , and three grey buttons at the 
> top.

Could you please recompile your kernel with CONFIG_HID_DEBUG (2.6.21-rc1 
or any newer) and send me the output both from the time you connect the 
device in the USB port, and also when you press the non-functional keys?

Thanks,

-- 
Jiri Kosina
