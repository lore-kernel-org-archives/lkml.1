Return-Path: <linux-kernel-owner+w=401wt.eu-S1754927AbZKEPSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927AbZKEPSo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 10:18:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755635AbZKEPSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 10:18:12 -0500
Received: from cantor.suse.de ([195.135.220.2]:37089 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755385AbZKEPSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 10:18:10 -0500
Date: Thu, 5 Nov 2009 16:18:15 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Davidlohr Bueso <dave@gnu.org>
Cc: dougthompson@xmission.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation/edac
In-Reply-To: <1257359434.5291.5.camel@dbueso-pc>
Message-ID: <alpine.LSU.2.00.0911051616530.9988@wotan.suse.de>
References: <1257359434.5291.5.camel@dbueso-pc>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Nov 2009, Davidlohr Bueso wrote:

> ---
>  Documentation/edac.txt |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/edac.txt b/Documentation/edac.txt
> index 06f8f46..79c5332 100644
> --- a/Documentation/edac.txt
> +++ b/Documentation/edac.txt
> @@ -80,7 +80,7 @@ is:
>  
>  	broken_parity_status
>  
> -as is located in /sys/devices/pci<XXX>/0000:XX:YY.Z directorys for
> +as is located in /sys/devices/pci<XXX>/0000:XX:YY.Z directories for
>  PCI devices.
>  
>  FUTURE HARDWARE SCANNING
> @@ -288,9 +288,8 @@ Total UE count that had no information attribute fileY:
>  
>  	'ue_noinfo_count'
>  
> -	This attribute file displays the number of UEs that
> -	have occurred have occurred with  no informations as to which DIMM
> -	slot is having errors.
> +	This attribute file displays the number of UEs that have occurred
> +	with no information as to which DIMM slot is having errors.
>  

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
