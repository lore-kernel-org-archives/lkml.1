Return-Path: <linux-kernel-owner+w=401wt.eu-S1750868AbXCLPGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750868AbXCLPGL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 11:06:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030306AbXCLPGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 11:06:11 -0400
Received: from mx1.suse.de ([195.135.220.2]:44589 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbXCLPGK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 11:06:10 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: Mark Lord <lkml@rtr.ca>
Subject: Re: [BUG} usb-serial regression in 2.6.21-rc2-git3
Date: Mon, 12 Mar 2007 16:06:05 +0100
User-Agent: KMail/1.9.1
Cc: Adrian Bunk <bunk@stusta.de>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <45EB9DC6.8010403@rtr.ca> <45F56A2D.9010808@rtr.ca>
In-Reply-To: <45F56A2D.9010808@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703121606.06601.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 12. März 2007 15:56 schrieb Mark Lord:
> Still no improvement on the b0rken usb-serial resume support in -rc*.

Have you applied the fixes in Greg's current tree?

	Regards
		Oliver

