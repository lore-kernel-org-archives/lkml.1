Return-Path: <linux-kernel-owner+w=401wt.eu-S1754271AbXFXUyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbXFXUyx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 16:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751017AbXFXUyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 16:54:47 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:2887 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbXFXUyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 16:54:46 -0400
Date: Sun, 24 Jun 2007 22:54:45 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: linux-kernel@vger.kernel.org, arjan@linux.intel.com,
       Alan Piszcz <ap@solarrain.com>
Subject: Re: IRQ Balance Question for Single but Multi-Core Processors
In-Reply-To: <Pine.LNX.4.64.0706241627470.5819@p34.internal.lan>
Message-ID: <Pine.LNX.4.64.0706242252590.11964@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0706241627470.5819@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 24 2007 16:29, Justin Piszcz wrote:
>
> Question regarding the IRQ balance daemon and the 2.6.x kernel.
>
> For a single-processor but dual or quad core CPU, should one be running the IRQ
> balancing daemon, will it result in increased performance?
>
> Or is IRQ balance mainly targeted at physical multi-processor systems?

There must be a reason it exists :)
For MC or MP or MCMP systems, it should be helpful indeed.
HT however, not so sure. But then again, MCHT and MCMPHT maybe.

(multi-core, multi-processor, hyperthreading, and combinations thereof.)


	Jan
-- 
