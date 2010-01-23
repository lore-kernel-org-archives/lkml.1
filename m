Return-Path: <linux-kernel-owner+w=401wt.eu-S1755998Ab0AWST7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab0AWST7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 13:19:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887Ab0AWST6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 13:19:58 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:57091 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352Ab0AWST5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 13:19:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=F4jRraYsgbT9LlAA0FuUj2Of3P59kE09uE48V3ouacdNGDsipjZtsCvivuvknSWaIm
         s9yPjlWbUJkE77ahPcwUxBESbdGcJ4xUqrxon37UhYX2AfkH5dW+IZVrllb5z9/1iPIW
         wmil7M7LVogX0+DWYsLFJGk2ZE3+ilO11Mivw=
Date: Sat, 23 Jan 2010 19:18:17 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-fbdev@vger.kernel.org,
       nouveau@lists.freedesktop.org
Subject: Re: 2.6.33 vs. NVIDIA GForce GT 220
Message-ID: <20100123181817.GA2909@joi.lan>
References: <20100112134335.GA21783@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100112134335.GA21783@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 02:43:35PM +0100, Pavel Machek wrote:
> Hi!
> 
> I tried enabling staging nvidia driver on GT220, but apparently driver
> does not know about it. Unfortunately, I have one of those cards here.
> 
> (I wonder... is there better mailing list? MAINTAINERS only lists
> linux-fbdev....)

CC'ing proper mailing list
