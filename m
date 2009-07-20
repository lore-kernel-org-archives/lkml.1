Return-Path: <linux-kernel-owner+w=401wt.eu-S1751654AbZGTPDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654AbZGTPDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 11:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbZGTPDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 11:03:07 -0400
Received: from ns2.gothnet.se ([82.193.160.251]:51107 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751119AbZGTPDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 11:03:06 -0400
Message-ID: <4A648718.9000709@shipmail.org>
Date: Mon, 20 Jul 2009 17:02:48 +0200
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@shipmail.org>
Organization: VMware
User-Agent: Thunderbird 1.5.0.7 (X11/20060921)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: DRI <dri-devel@lists.sourceforge.net>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: DRM drivers with closed source user-space: WAS  [Patch 0/3]	Resubmit
 VIA Chrome9 DRM via_chrome9 for upstream
References: <4A647358.1040009@shipmail.org> <20090720135844.GA16844@infradead.org>
In-Reply-To: <20090720135844.GA16844@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-BitDefender-Scanner: Mail not scanned due to license constraints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
>
>
> I think you're just trying to push your agenda.  
>
> I think you're just trying to defend your business writing closed source
> drivers.  Drivers that aren't usable without binary blobs don't have
> a business in the kernel tree, and your whining doesn't help it.  You'd
> be better off spending your time getting proper open drivers done than
> defending doing the work to support closed binaries.
>   

You obviously got all this completely wrong.

I avoid writing closed source drivers whenever I can, I'm not whining 
and I'm not trying to push any of them. The code VIA is trying to submit 
has not been written by me nor anybody I know. All VIA code I and the 
companies I've worked for has written is open-sourced and contributed to 
the Openchrome / mesa / drm project.

The point I'm trying to make is the following:

If the common agreement of the linux community is to *NOT* allow these 
drivers in, so be it, then be honest and go ahead and tell the driver 
writers. Don't make them respin their development trying to fix minor 
flaws when their driver won't get in anyway!

/Thomas







