Return-Path: <linux-kernel-owner+w=401wt.eu-S933307AbZJIOgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933307AbZJIOgt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 10:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756210AbZJIOgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 10:36:48 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:6750 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932110AbZJIOgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 10:36:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=k44LV/8ZIn5Xfbzz2SCoALohEXkel0FdK2h2bm17ZAbvFGy0taCE9couEGBs4Djf+5
         3y2dBXzBUtkhgwc39tPy8NmfKLxYL37Y3NEw4v7PiKzw5meyqyJF4Zo3Ewn44HoYSMps
         tO3e2HI7EIlBTYLw/ml5tVLePlKGMdvCxdmTE=
Message-ID: <4ACF4A0C.60508@lwfinger.net>
Date: Fri, 09 Oct 2009 09:34:52 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-2.1 Thunderbird/3.0b4
MIME-Version: 1.0
To: Miguel Boton <waninkoko@gmail.com>
CC: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, mb@bu3sch.de,
       linville@tuxdriver.com, bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] b43: add 'struct b43_wl' missing declaration
References: <200910091613.53960.mboton@gmail.com>
In-Reply-To: <200910091613.53960.mboton@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2009 09:13 AM, Miguel Boton wrote:
> 'struct b43_wl' declaration is missing at 'leds.h'.
> It should be declared to avoid getting some GCC warnings at 'b43_leds_unregister'.
> 
> Signed-off-by: Miguel Botón <mboton@gmail.com>

What architecture? There must be something strange with your
configuration as I see no such warnings. Please post your .CONFIG.

Larry

