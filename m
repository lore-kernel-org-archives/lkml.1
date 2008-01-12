Return-Path: <linux-kernel-owner+w=401wt.eu-S1759762AbYALSZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759762AbYALSZq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 13:25:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756916AbYALSZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 13:25:38 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:33444 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756619AbYALSZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 13:25:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=xhjFYBJXvl+orFWtwbzYYhJeSo13iLELEdWlxmZlln+2MX3Gv+KKBIdnJhCuhbsB3whvT9oj8UQecruX3D3uUK7yCBzEgcbpNgyaJFddPSHRifPX6D7ExPvmFQwBKBcGNpHlUpFNU+QDeIXnvI/5UT5ZbSXbOKbfZ8ty37USedo=
Message-ID: <2c0942db0801121025h7f22d716s657af75ce7603af0@mail.gmail.com>
Date: Sat, 12 Jan 2008 10:25:34 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Renato S. Yamane" <renatoyamane@mandic.com.br>
Subject: Re: Updatedb hangs Kernel 2.6.22.9-cfs-v22
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <478900FF.2000706@mandic.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <478900FF.2000706@mandic.com.br>
X-Google-Sender-Auth: 998fafdf87cabd1d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 12, 2008 10:03 AM, Renato S. Yamane <renatoyamane@mandic.com.br> wrote:
> Hi,
> I can't use updatedb in Debian Etch (stable) using customized Kernel
> 2.6.22.9-cfs-v22.
>
> When I ran updatedb, after ~1 minute my system hangs and "caps lock" LED
> is blinking. No log is registered.

Please switch out of X11 to a text mode console (CTRL-ALT-F1), and run
updatedb there. Capture the oops with a digital camera, and post a
link to the picture (not the picture itself!) to the list. Or, write
down the oops carefully, and post the text.
