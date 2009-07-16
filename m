Return-Path: <linux-kernel-owner+w=401wt.eu-S933586AbZGPXP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933586AbZGPXP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 19:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933578AbZGPXP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 19:15:26 -0400
Received: from kroah.org ([198.145.64.141]:52497 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933550AbZGPXPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 19:15:21 -0400
Date: Thu, 16 Jul 2009 16:02:16 -0700
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: swetland@google.com, malchev@google.com, san@android.com,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: HTC Dream: rpcrouter for staging
Message-ID: <20090716230216.GD3609@kroah.com>
References: <20090710085024.GA6665@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090710085024.GA6665@elf.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 10, 2009 at 10:50:25AM +0200, Pavel Machek wrote:
> From: Brian Swetland <swetland@google.com>, Iliyan Malchev <ibm@android.com>, San Mehat <san@android.com>
> 
> rpcrouter code is neccessarry for communication with QDSP and thus
> many hardware components on HTC Dream, including camera hardware.

Same problem here, no Makefile / Kconfig hooks :(

thanks,

greg k-h
