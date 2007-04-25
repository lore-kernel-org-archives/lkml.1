Return-Path: <linux-kernel-owner+w=401wt.eu-S1030827AbXDYTdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030827AbXDYTdh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 15:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031106AbXDYTdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 15:33:36 -0400
Received: from smtp1-g19.free.fr ([212.27.42.27]:42944 "EHLO smtp1-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030827AbXDYTdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 15:33:36 -0400
From: Duncan Sands <duncan.sands@math.u-psud.fr>
To: Simon Arlott <simon@fire.lp0.eu>
Subject: Re: [PATCH (rev 2)] cxacru: Cleanup sysfs attribute code
Date: Wed, 25 Apr 2007 21:33:43 +0200
User-Agent: KMail/1.9.6
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
References: <462E730F.3090401@simon.arlott.org.uk> <11882.simon.1177499883@5ec7c279.invalid> <462FA0D0.9040901@simon.arlott.org.uk>
In-Reply-To: <462FA0D0.9040901@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704252133.43690.duncan.sands@math.u-psud.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 April 2007 20:41:20 Simon Arlott wrote:
> This changes the format of unknown status values to be less verbose and 
> uses an array instead of several different snprintf calls. Since only 
> enum values are assigned to it, poll_state is changed from int to enum. 
> Use abs() for dB values instead of two almost identical return lines.
> 
> Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Duncan Sands <duncan.sands@math.u-psud.fr>

Acked-by: Duncan Sands <baldrick@free.fr>

> Cc: Andrew Morton <akpm@linux-foundation.org>
