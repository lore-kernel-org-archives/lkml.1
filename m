Return-Path: <linux-kernel-owner+w=401wt.eu-S1757500AbXI0Rii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500AbXI0Rii (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 13:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbXI0Rib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 13:38:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53656 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbXI0Ria (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 13:38:30 -0400
Message-ID: <46FBEA85.4020300@zytor.com>
Date: Thu, 27 Sep 2007 10:38:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
CC: device <device@lanana.org>
Subject: Re: Add /dev/oldmem to devices.txt documenation.
References: <20070927155109.GA21668@redhat.com>
In-Reply-To: <20070927155109.GA21668@redhat.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> Signed-off-by: Dave Jones <davej@redhat.com>
> 
> diff --git a/Documentation/devices.txt b/Documentation/devices.txt
> index 8de132a..6c46730 100644
> --- a/Documentation/devices.txt
> +++ b/Documentation/devices.txt
> @@ -94,6 +94,8 @@ Your cooperation is appreciated.
>  		  9 = /dev/urandom	Faster, less secure random number gen.
>  		 10 = /dev/aio		Asynchronous I/O notification interface
>  		 11 = /dev/kmsg		Writes to this come out as printk's
> +		 12 = /dev/oldmem	Used by crashdump kernels to access
> +					the memory of the kernel that crashed.
>  
>    1 block	RAM disk
>  		  0 = /dev/ram0		First RAM disk

This should have been sent to device@lanana.org as well.

	-hpa
