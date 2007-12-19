Return-Path: <linux-kernel-owner+w=401wt.eu-S1754999AbXLSTOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999AbXLSTOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 14:14:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbXLSTOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 14:14:35 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:14288 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbXLSTOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 14:14:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=oQPW020AXbEUBpljPSHjHeu26K/19jKPxklReF8Zg9FussaJojBBagGq0FWlktfEKvyL7FTr8ay9lJGquQL7Z+nPOJTtUMxTQKNimYBD2lxojgRuQ31pPonXONWxmuGgLwW01VbrOznZNGigLwftlY5gLFXx8k9oqdlIEwEvNhI=
Message-ID: <47696D95.3030604@gmail.com>
Date: Wed, 19 Dec 2007 20:14:29 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Parag Warudkar <parag.warudkar@gmail.com>
CC: Nico Schottelius <nico-kernel-20071219@schottelius.org>,
       Robert Hancock <hancockr@shaw.ca>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Out of memory and no killable processes: 2.6.22-2-686-bigmem
References: <fa.oSel00y9Hn5hvV3laxPiw9blEfU@ifi.uio.no> <4768692A.3030204@shaw.ca> <20071219055550.GE21042@denkbrett.schottelius.org> <Pine.LNX.4.64.0712190340090.8597@mini.warudkars.net>
In-Reply-To: <Pine.LNX.4.64.0712190340090.8597@mini.warudkars.net>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2007 09:56 AM, Parag Warudkar wrote:
> running on 64-bit kernel. [Also I hear the closed source nVidia binaries
> will not work on this setup - so if you don't need such things you will
> be able to go to a 64-bit kernel w/o reinstalling userspace.]

False, I'm running 100-* nvidia drivers on such set up system. However some
drivers might be broken due to unimplemented (not filled) compat_ioctl.
