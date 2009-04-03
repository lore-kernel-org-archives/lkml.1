Return-Path: <linux-kernel-owner+w=401wt.eu-S1759992AbZDCVPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759992AbZDCVPZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 17:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbZDCVPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 17:15:07 -0400
Received: from tichy.grunau.be ([85.131.189.73]:48273 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515AbZDCVPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 17:15:06 -0400
Date: Fri, 3 Apr 2009 23:14:38 +0200
From: Janne Grunau <j@jannau.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] LANANA: Change of management and resync
Message-ID: <20090403211438.GA25887@aniel>
References: <20090403135051.19177.23019.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090403135051.19177.23019.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 02:50:52PM +0100, Alan Cox wrote:
> Bring the devices.txt back into some relationship with reality. Update the
> documentation a bit.
> 
> Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
> ---
> 
>  Documentation/devices.txt |  121 ++++++++++++++++++++++-----------------------
>  1 files changed, 58 insertions(+), 63 deletions(-)
> 
> 
> diff --git a/Documentation/devices.txt b/Documentation/devices.txt
> index 62254d4..85a6a6d 100644
> --- a/Documentation/devices.txt
> +++ b/Documentation/devices.txt
> @@ -1,7 +1,7 @@
>  
>  		    LINUX ALLOCATED DEVICES (2.6+ version)
>  
> -	     Maintained by Torben Mathiasen <device@lanana.org>
> +	     Maintained by Alan Cox <device@lanana.org>
>  
>  		      Last revised: 29 November 2006

date should probably be updated


Janne
