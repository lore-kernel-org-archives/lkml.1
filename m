Return-Path: <linux-kernel-owner+w=401wt.eu-S1758483AbZGGUHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758483AbZGGUHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 16:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756008AbZGGUGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 16:06:51 -0400
Received: from mail.gmx.net ([213.165.64.20]:42131 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754888AbZGGUGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 16:06:50 -0400
X-Authenticated: #787645
X-Provags-ID: V01U2FsdGVkX1+cAHxP4tWckJHEGKI3JOhlqJ0WqmGpCyqh4i2QcG
	2+yDw1UJntSS9U
Message-ID: <4A53AAD1.1050308@gmx.net>
Date: Tue, 07 Jul 2009 22:06:41 +0200
From: Witold Szczeponik <Witold.Szczeponik@gmx.net>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Thomas Renninger <trenn@suse.de>, stable@kernel.org, rjw@sisk.pl,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       abelay@mit.edu, bjorn.helgaas@hp.com
Subject: Re: [stable] [PATCH] PNPACPI: Enable PNPACPI _PSx Support, v3
References: <49D101DA.50201@gmx.net> <200904021510.37517.trenn@suse.de> <20090630230314.GD2634@kroah.com>
In-Reply-To: <20090630230314.GD2634@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:

[snip]

> 
> What specific git commit id in Linus's tree is this?
> 
> thanks,
> 
> greg k-h
> 

Hi Greg,

the git commit id of this patch would be 
6328a57401dc5f5cf9931738eb7268fcd8058c49, but the patch triggered a 
regression which is described in 
http://bugzilla.kernel.org/show_bug.cgi?id=13243 and which was fixed in 
19bde778c1fd2574cc020a618d7d576f260271ca.

Hope this helps.


--- Witold
