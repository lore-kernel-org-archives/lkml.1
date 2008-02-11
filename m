Return-Path: <linux-kernel-owner+w=401wt.eu-S1757566AbYBKQCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566AbYBKQCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 11:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755080AbYBKQCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 11:02:06 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:39590 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754697AbYBKQCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 11:02:04 -0500
Date: Mon, 11 Feb 2008 17:02:11 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan-Bernd Themann <ossthema@de.ibm.com>
Cc: Dave Hansen <haveblue@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>, linux-ppc <linuxppc-dev@ozlabs.org>,
       Thomas Klein <osstklei@de.ibm.com>,
       "Themann, Jan-Bernd" <themann@de.ibm.com>, Greg KH <greg@kroah.com>,
       Christoph Raisch <RAISCH@de.ibm.com>
Subject: Re: [PATCH] drivers/base: export gpl (un)register_memory_notifier
Message-ID: <20080211160211.GA22139@uranus.ravnborg.org>
References: <200802111657.07534.ossthema@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802111657.07534.ossthema@de.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 04:57:06PM +0100, Jan-Bernd Themann wrote:
> Drivers like eHEA need memory notifiers in order to 
> update their internal DMA memory map when memory is added
> to or removed from the system.

Can you please add proper kernel-doc formatted comments
when you export a symbol so others can get a clue
what the exported function is supposed to do.

	Sam
