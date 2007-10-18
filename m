Return-Path: <linux-kernel-owner+w=401wt.eu-S1764130AbXJRLpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764130AbXJRLpl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 07:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761893AbXJRLpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 07:45:23 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:55812 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761765AbXJRLpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 07:45:21 -0400
Date: Thu, 18 Oct 2007 13:46:53 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kbuild: filter out .tmp_* in find_sources
Message-ID: <20071018114653.GB19539@uranus.ravnborg.org>
References: <200710160028.06468.yinghai.lu@sun.com> <200710171643.40345.yinghai.lu@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710171643.40345.yinghai.lu@sun.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2007 at 04:43:39PM -0700, Yinghai Lu wrote:
> [PATCH] kbuild: filter out .tmp_* in find_sources
> 
> remove .tmp_kallsyms*.S in cscope.files
> 
> Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Thanks - applied,

	Sam
