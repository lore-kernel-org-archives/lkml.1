Return-Path: <linux-kernel-owner+w=401wt.eu-S1754868AbYJWIFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbYJWIFe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 04:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751822AbYJWIFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 04:05:07 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:38213
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751631AbYJWIFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 04:05:01 -0400
X-IronPort-AV: E=Sophos;i="4.33,469,1220220000"; 
   d="scan'208";a="18406136"
Date: Thu, 23 Oct 2008 10:04:59 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Robert Moss <robert.von.moss@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Framebuffer issues in 2.6.26 with uvesafb and vesafb. Linux is about choice!
Message-ID: <20081023080459.GC5073@const.bordeaux.inria.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Robert Moss <robert.von.moss@gmail.com>,
	linux-kernel@vger.kernel.org
References: <6ffd69180810230054s3b6aff5y880a898c3fc66a37@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6ffd69180810230054s3b6aff5y880a898c3fc66a37@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Moss, le Thu 23 Oct 2008 00:54:56 -0700, a écrit :
> Anyhow, I noticed that vesafb is no longer a part of the kernel.

That's not true. It works nicely on my laptop (though I don't get
the native 1280x800 resolution).

> vga=791 still gave a mode not found.

Then that's a bug, which is a completely different thing. Could you
check that the output of vga=ask and typing scan at the boot prompt is
the same between 2.6.24 and 2.6.25/26 ?

Samuel, who may want to try 2.6.24 to get his native resolution.
