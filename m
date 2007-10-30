Return-Path: <linux-kernel-owner+w=401wt.eu-S1753489AbXJ3AkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbXJ3AkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 20:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbXJ3AkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 20:40:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33184 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875AbXJ3AkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 20:40:03 -0400
Date: Mon, 29 Oct 2007 20:39:59 -0400
From: Dave Jones <davej@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: 32bit builds on x86-64 host.
Message-ID: <20071030003959.GK1650@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Sam Ravnborg <sam@ravnborg.org>
References: <20071029233231.GI7793@redhat.com> <472675AC.3070509@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <472675AC.3070509@zytor.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2007 at 05:07:08PM -0700, H. Peter Anvin wrote:
 > Dave Jones wrote:
 > > Before the arch merge, I frequently would test 32bit compiles
 > > by doing make ARCH=i386 {bzImage/modules/file.o}
 > > 
 > > Since commit 47572387d58a9584c60ebbbdee56fc92c627f16f
 > > how does one do this?
 > > 
 > 
 > make ARCH=i386 {bzImage/modules/file.o}
 > 
 > Amazing, isn't it?

It's like the future.   I'm not sure why that didn't work for me.
Must be something in my dirty tree.

	Dave
-- 
http://www.codemonkey.org.uk
