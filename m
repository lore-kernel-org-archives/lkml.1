Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbYKCVpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbYKCVpe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 16:45:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbYKCVpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 16:45:19 -0500
Received: from kroah.org ([198.145.64.141]:33057 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752568AbYKCVpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 16:45:18 -0500
Date: Mon, 3 Nov 2008 13:40:46 -0800
From: Greg KH <greg@kroah.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Subbu Seetharaman <subbus@serverengines.com>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND] benet: BladeEngine 10Gb NIC driver
Message-ID: <20081103214046.GA13796@kroah.com>
References: <20081103122512.06063fc9@mailhost.serverengines.com> <20081103193641.GA12552@kroah.com> <490F5667.3080904@garzik.org> <20081103201930.GB13299@kroah.com> <490F6234.4060805@garzik.org> <20081103204619.GA19936@kroah.com> <490F653D.2080902@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490F653D.2080902@garzik.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2008 at 03:55:25PM -0500, Jeff Garzik wrote:
> Greg KH wrote:
>> Ok, that worked just fine, sorry for the noise, I was trying to be
>
> Cool...
>
>
>> "nice" and not use 'git pull' and use 'git fetch' like I thought I was
>> supposed to be doing :)
>
> Curious...  does "nice" mean nicer to the server, i.e. less expensive and 
> faster to calculate a download?

No, sorry, "nice" on my side so that a merge would not happen, just a
fetch, so I could see the patches and not have to worry about any merge
issues.

thanks,

greg k-h
