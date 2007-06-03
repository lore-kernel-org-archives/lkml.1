Return-Path: <linux-kernel-owner+w=401wt.eu-S1760335AbXFCLBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760335AbXFCLBQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 07:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756745AbXFCLBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 07:01:05 -0400
Received: from twin.jikos.cz ([213.151.79.26]:41288 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097AbXFCLBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 07:01:05 -0400
Date: Sun, 3 Jun 2007 13:00:52 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel 2.6.22-rc3 breaks USB: Unable to get HID descriptor (error
 sending control message: Operation not permitted)
In-Reply-To: <Pine.LNX.4.64.0706030634400.3574@p34.internal.lan>
Message-ID: <Pine.LNX.4.64.0706031300240.29896@twin.jikos.cz>
References: <Pine.LNX.4.64.0706021841520.3376@p34.internal.lan>
 <Pine.LNX.4.64.0706031146470.29896@twin.jikos.cz>
 <Pine.LNX.4.64.0706030634400.3574@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Jun 2007, Justin Piszcz wrote:

> Sure, they are attached:
> $ du -sh nut*
> 4.0K    nut-bad.txt.bz2 (2.6.22-rc3)
> 12K     nut-good.txt.bz2 (2.6.21.3)
> Let me know if they are of any use.

Thanks. Does by any chance reverting 
the commit 9f8b17e643fe6aa505629658445849397bda4e4f improve the situation?

-- 
Jiri Kosina
