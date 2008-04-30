Return-Path: <linux-kernel-owner+w=401wt.eu-S1764178AbYD3ShO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764178AbYD3ShO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 14:37:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759786AbYD3Sg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 14:36:56 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:27984 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762793AbYD3Sgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 14:36:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZGL9A99CFI7dccNsDBhQICILLAf63Cxuqa4LEoAeJsWHTf3v4oIclbUPbMNdH21WOLTiGQMlV4PyjVSWF4DWRiMJvX2vDbOC1j+Z5rxP0b3yAMsZWYzzt+qfsC5KVa6zqW8gm1J4tUdeEZ4PRJIKls1Ms5ObDGjUwHqBvf0gj3Q=
Message-ID: <5d5443650804301129s552ddbfchfb98c732233f3905@mail.gmail.com>
Date: Wed, 30 Apr 2008 23:59:53 +0530
From: "Trilok Soni" <soni.trilok@gmail.com>
To: "Rajagopal Venkat" <rajagopal.venkat@gmail.com>
Subject: Re: Booting OMAP5912 with 2.6.8 kernel
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <eb17f2110804300616s29e03185p116717f3d259e3e0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <eb17f2110804300415p3c0e881bl22fe5eb7e614f84e@mail.gmail.com>
	 <eb17f2110804300616s29e03185p116717f3d259e3e0@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rajagopal,

On Wed, Apr 30, 2008 at 6:46 PM, Rajagopal Venkat
<rajagopal.venkat@gmail.com> wrote:
> Hi,
>
>  I am newbie to LINUX and OMAP5912 as well. I have been trying to boot
>  5912 OSK with 2.6.8 kernel downloaded from TI site following
>  instructions given in "How to Build Linux for the OMAP5912 Processor"
>  document. But i could not succeed.
>
>  Here is the error message when kernel is booted:
>
>
>  ## Booting image at 00100000 ...
>   Image Name:   Linux Kernel Image
>   Image Type:   ARM Linux Kernel Image (gzip compressed)
>   Data Size:    862446 Bytes = 842.2 kB
>   Load Address: 10c08000
>   Entry Point:  10c08000
>   Verifying Checksum ... OK
>   Uncompressing Kernel Image ... OK
>
>  Starting kernel ...
>
>  Linux version 2.6.8-rc3-omap1 (user@knoppix-box) (gcc version 3.3.2)

We are now moved to vger.kernel.org based OMAP list, so removing old
list. Your kernel version looks very old. Could you please try the
kernel from OMAP GIT. You can find instructions at
http://www.muru.com/linux/omap. GIT tree is at

http://source.mvista.com/git and also at http://www.kernel.org/git.

-- 
---Trilok Soni
http://triloksoni.wordpress.com
