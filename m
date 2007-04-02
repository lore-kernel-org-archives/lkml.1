Return-Path: <linux-kernel-owner+w=401wt.eu-S933955AbXDBG5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933955AbXDBG5u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 02:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933960AbXDBG5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 02:57:50 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:18880 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933955AbXDBG5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 02:57:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HsrRaB/kv0btiti2fDBGhmDGc37Rh11XEIqe+JHGKngufm7njNvB+p68mzZ3xY+jke8rX+BzonUrxC95O14ODhqt8LVX25Fzag47dQzdjeqaBZmwAB8WkTbVxSpMO8B+ynoNqr1Q9tsTA2fDS0PrhznVDRQWdheXhFXYH6UEnb8=
Subject: Re: [PATCH 3/16] vt-underline-color.diff
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
In-Reply-To: <Pine.LNX.4.61.0704012002570.12316@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
	 <Pine.LNX.4.61.0704012002570.12316@yvahk01.tjqt.qr>
Content-Type: text/plain
Date: Mon, 02 Apr 2007 14:57:37 +0800
Message-Id: <1175497057.4614.18.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-01 at 20:14 +0200, Jan Engelhardt wrote:
> Add color support to the "underline" and "italic" attributes as in
> OpenBSD/NetBSD-style (vt220) and xterm.

The italic attribute is indeed part of ANSI standard, though not widely
implemented. Fbcon (monochrome mode) already supports inverse,
underline, and bold. I'll try to implement italics (if I can) too if
this gets in.

> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Acked-by: Antonino Daplas <adaplas@gmail.com>

Tony

