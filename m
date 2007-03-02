Return-Path: <linux-kernel-owner+w=401wt.eu-S1030650AbXCBWaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030650AbXCBWaS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 17:30:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030651AbXCBWaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 17:30:18 -0500
Received: from de01egw01.freescale.net ([192.88.165.102]:63662 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030650AbXCBWaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 17:30:17 -0500
Message-ID: <45E8A571.9030601@freescale.com>
Date: Fri, 02 Mar 2007 16:30:09 -0600
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.2pre) Gecko/20070111 SeaMonkey/1.1
MIME-Version: 1.0
To: Mike Accetta <maccetta@laurelnetworks.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Someone please turn on the http protocol on git.kernel.org!
References: <7TYYU-5L8-11@gated-at.bofh.it> <7U2zx-392-13@gated-at.bofh.it> <45E8220D.9040905@laurelnetworks.com>
In-Reply-To: <45E8220D.9040905@laurelnetworks.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Accetta wrote:

> error: Couldn't get 
> http://www.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git/refs/tags/v2.6.11 
> for tags/v2.6.11
> The requested URL returned error: 404
> error: Could not interpret tags/v2.6.11 as something to pull

I just tried it and got the same error, so it looks like something is wrong on the server.

Isn't 2.6.11 around the time that Linus moved to git?  Maybe the server can't find tag for 
the initial check-in of the code.

-- 
Timur Tabi
Linux Kernel Developer @ Freescale
