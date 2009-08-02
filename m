Return-Path: <linux-kernel-owner+w=401wt.eu-S1753104AbZHBQ0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbZHBQ0H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 12:26:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753008AbZHBQ0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 12:26:06 -0400
Received: from are.twiddle.net ([75.149.56.221]:36802 "EHLO are.twiddle.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862AbZHBQ0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 12:26:06 -0400
Message-ID: <4A75BE14.50908@twiddle.net>
Date: Sun, 02 Aug 2009 09:25:56 -0700
From: Richard Henderson <rth@twiddle.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Tim Abbott <tabbott@ksplice.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Anders Kaseorg <andersk@ksplice.com>,
       Nelson Elhage <nelhage@ksplice.com>, linux-alpha@vger.kernel.org
Subject: Re: [PATCH 1/2] alpha: use .data.init_task instead of .data.init_thread.
References: <1249073786-29788-1-git-send-email-tabbott@ksplice.com> <4A7360C3.2060507@twiddle.net> <alpine.DEB.1.10.0907311739040.2539@vinegar-pot.mit.edu> <4A737EB1.1000602@twiddle.net> <alpine.DEB.1.10.0907311933360.2539@vinegar-pot.mit.edu>
In-Reply-To: <alpine.DEB.1.10.0907311933360.2539@vinegar-pot.mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2009 04:56 PM, Tim Abbott wrote:
> Also, some explicit ALIGN(8)'s between various initcall sections were
> removed; this should be harmless as the implicit alignment of
> initcall_t was already 8.
>
> Signed-off-by: Geoffrey Thomas<geofft@ksplice.com>
> Signed-off-by: Tim Abbott<tabbott@ksplice.com>
> Cc: Richard Henderson<rth@twiddle.net>
> Cc: Ivan Kokshaysky<ink@jurassic.park.msu.ru>
> Cc: Sam Ravnborg<sam@ravnborg.org>

Signed-off-by: Richard Henderson <rth@twiddle.net>


r~
