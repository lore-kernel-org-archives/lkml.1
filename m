Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab0BRJyk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 04:54:40 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:34519 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754776Ab0BRJyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 04:54:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LPe936GuHzTG7clbBv6Aik/Z+/mjQnkznEjhJz4S3I55PoYt3PAwlo8LHgRzl64pwO
         iBQsH1f8F2MhV99qfo0PlbaEDOYtmSSdjyEr8VeYzFHpUA9ZWD4sv2FBnlii9cMrltEM
         PfZlo54BiVSgpWE/SbtMoaLgjkt2Sa69AMXkQ=
Date: Thu, 18 Feb 2010 01:54:33 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Christopher Heiny <cheiny@synaptics.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Allie Xiong <axiong@synaptics.com>,
       William Manson <wmanson@synaptics.com>
Subject: Re: [RFC PATCH 0/1] input/touchscreen: Synaptics Touchscreen Driver
Message-ID: <20100218095433.GE13086@core.coreip.homeip.net>
References: <1266446258-16209-1-git-send-email-cheiny@synaptics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266446258-16209-1-git-send-email-cheiny@synaptics.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christopher,

On Wed, Feb 17, 2010 at 02:37:36PM -0800, Christopher Heiny wrote:
> [This is a resend of a patch sent earlier this month - apologies
> for the duplication, but I botched some of the addressing in the
> previous submission (neglecting to include Dmitry), as well as the
> cover note.]
> 
> This patch adds an initial driver supporting Synaptics ClearPad
> touchscreens that use the RMI4 protocol, as defined here:
> 
> http://www.synaptics.com/sites/default/files/511-000136-01_revA.pdf
> 
> 
> Differences to the previous RFC PATCH sent include:
>     - proper line wrapping (sending with get-sendemail)
>     - extensive changes to make checkpatch.pl happy.  Not all errors were
>       eliminated, because in a couple of cases we couldn't figure out what the
>       problem was.
>     - i2c interface updated to reflect recent i2c changes in the kernel.
> 


Thank you for making the changes and yes, please CC me and linux-input
mailing list on the subsequent submissions - this way you should
normally get quicker response.

PLease give me a couple days to look over the driver and ping me if you
don't hear from me.

-- 
Dmitry
