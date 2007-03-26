Return-Path: <linux-kernel-owner+w=401wt.eu-S1752456AbXCZMmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbXCZMmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 08:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbXCZMmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 08:42:39 -0400
Received: from bigmama.rhoen.de ([62.80.125.185]:33752 "EHLO rhoen.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752456AbXCZMmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 08:42:38 -0400
X-Greylist: delayed 1071 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Mar 2007 08:42:38 EDT
Date: Mon, 26 Mar 2007 14:02:39 +0200
To: Sid Boyce <g3vbv@blueyonder.co.uk>
Cc: Adrian Bunk <bunk@stusta.de>, Randy Dunlap <randy.dunlap@oracle.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, auxsvr@gmail.com
Subject: Re: 2.6.21-rc1 and 2.6.21-rc2 kwin dies silently
Message-ID: <20070326120238.GA16816@macbeth.rhoen.de>
References: <200702281805.13822.auxsvr@gmail.com> <20070307214730.87859590.akpm@linux-foundation.org> <45EFBC73.2030005@blueyonder.co.uk> <46016EAF.6010801@blueyonder.co.uk> <20070321193420.GP752@stusta.de> <m17itabbbv.fsf@ebiederm.dsl.xmission.com> <4601DCB4.4060804@blueyonder.co.uk> <20070321184258.758a5a29.randy.dunlap@oracle.com> <20070322105908.GS752@stusta.de> <4602DDBC.5000106@blueyonder.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4602DDBC.5000106@blueyonder.co.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: boris <boris@macbeth.rhoen.de>
X-IN-Kompentent-e-V-MailScanner-Information: Please contact the ISP for more information
X-IN-Kompentent-e-V-MailScanner: Found to be clean
X-IN-Kompentent-e-V-MailScanner-From: boris@macbeth.rhoen.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2007 at 07:49:16PM +0000, Sid Boyce wrote:

> Kernel built and installed, so I shall have something to report in the
> next couple of days.

I see this kwin bug too
on a Thinkpad (x86_64) as well as on a Pmac (powerpc64).
It is only triggerd when the screen is locked AND! set
to standby mode (display/backlight is turned off - acpi).

boris

