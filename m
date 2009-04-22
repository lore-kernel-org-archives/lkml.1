Return-Path: <linux-kernel-owner+w=401wt.eu-S1755781AbZDVRlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781AbZDVRlj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 13:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754306AbZDVRlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 13:41:17 -0400
Received: from kroah.org ([198.145.64.141]:35181 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752942AbZDVRlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 13:41:16 -0400
Date: Wed, 22 Apr 2009 09:56:33 -0700
From: Greg KH <greg@kroah.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>,
       Darren Salt <linux@youmustbejoking.demon.co.uk>
Subject: Re: [PATCH 1/3] crc-itu-t: add bit-reversed calculation
Message-ID: <20090422165633.GD19524@kroah.com>
References: <1239590017.18110.120.camel@deadeye.i.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239590017.18110.120.camel@deadeye.i.decadent.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 13, 2009 at 03:33:37AM +0100, Ben Hutchings wrote:
> Signed-off-by: Darren Salt <linux@youmustbejoking.demon.co.uk>

Who wrote this patch, you or Darren?

If you, do you "sign off" on it?  And if you did it, does Darren really
also sign off on it?

I see that David has added the firmware to the linux-firmware tree and
done a release, so I'll be glad to take these patches now.  Care to
respin them with the proper authorship and signed-off-by information
again?

thanks,

greg k-h
