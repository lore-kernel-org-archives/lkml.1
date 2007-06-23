Return-Path: <linux-kernel-owner+w=401wt.eu-S1752759AbXFWVCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbXFWVCj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 17:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbXFWVCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 17:02:32 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46996 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbXFWVCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 17:02:31 -0400
Date: Sat, 23 Jun 2007 22:02:29 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Grozdan Nikolov <microchip@chello.be>, Torsten Duwe <duwe@lst.de>,
       linux-kernel@vger.kernel.org
Subject: Re: How innovative is Linux?
Message-ID: <20070623210228.GY21478@ftp.linux.org.uk>
References: <200706231417.16086.microchip@chello.be> <20070623164608.05dc5c30@the-village.bc.nu> <200706231812.02317.duwe@lst.de> <200706231819.43556.microchip@chello.be> <20070623202343.621a244b@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070623202343.621a244b@the-village.bc.nu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2007 at 08:23:43PM +0100, Alan Cox wrote:
> Proc type stuff is a lot older than Linux or Unix AFAIK. Loadable modules
> ditto but the full load/unload/autoload stuff I've not seen pre-Linux.

Representation of process state and control of that state via files on
a filesystem?  AFAIK, it's 80s stuff and at least one of the sources
had been research branch in Bell Labs - whether you call it Unix or not...

Do you have any references for that animal in earlier systems?  A lot
older than Unix would mean 50s or 60s...
