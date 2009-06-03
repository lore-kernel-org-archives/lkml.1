Return-Path: <linux-kernel-owner+w=401wt.eu-S1756446AbZFCKQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446AbZFCKQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 06:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752764AbZFCKQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 06:16:46 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:46910 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbZFCKQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 06:16:45 -0400
From: Markus <M4rkusXXL@web.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Seagate Barracuda 7200.11 ST31500341AS fw SD17
Date: Wed, 3 Jun 2009 12:16:44 +0200
User-Agent: KMail/1.9.10
Cc: Robert Hancock <hancockrwd@gmail.com>
References: <200906021258.20346.M4rkusXXL@web.de> <4A25F7B6.4080904@gmail.com>
In-Reply-To: <4A25F7B6.4080904@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906031216.44737.M4rkusXXL@web.de>
X-Provags-ID: V01U2FsdGVkX19wmkiIkiHJ8keFCXS5oxbtwhO2aF2HgW34HWWD
	ySXoSq4+kRBinHQQ+vJLYdIUOv5UuS3jJHLfNAqviIU9YVZRnp
	2OnhMpiSQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Markus wrote:
> > Now I want to know after what period of the time the kernel timeouts 
at 
> > these commands!? And if this timeout can be increased (manually, 
small 
> > patch for the kernel) and the min/max/avg time could somehow be 
> > messured. Every timeout kicks the drives off the raid, so I disabled 
> > the write cache (hdparm -W0 /dev/sdx) but thats no solution, just a 
bad 
> > workaround.
> 
> I believe the timeout for commands like these is usually 30 seconds. 
> Normally if it doesn't respond after that length of time, it never 
will. 
> Even if it eventually did, I don't think you'd be happy with disk 
access 
> delays of over 30 seconds..

Ok thats definitly bad. Will reask at the support...

Markus
