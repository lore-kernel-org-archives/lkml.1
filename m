Return-Path: <linux-kernel-owner+w=401wt.eu-S1760159AbXHEQtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760159AbXHEQtT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 12:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753417AbXHEQtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 12:49:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52208 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567AbXHEQtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 12:49:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [2/3] 2.6.23-rc2: known regressions
Date: Sun, 5 Aug 2007 18:58:11 +0200
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@ucw.cz>,
       Meelis Roos <mroos@linux.ee>
References: <46B5F74D.7010708@googlemail.com> <46B5FA32.50208@googlemail.com>
In-Reply-To: <46B5FA32.50208@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708051858.12404.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 5 August 2007 18:26, Michal Piotrowski wrote:
> Hi all,
> 
> Here is a list of some known regressions in 2.6.23-rc2.
> 
> Feel free to add new regressions/remove fixed etc.
> http://kernelnewbies.org/known_regressions
> 
 
> Power management
> 
> Subject         : Kconfig: 'SUSPEND_SMP' refers to undefined symbol 'HOTPLUG_CPU'
> References      : http://lkml.org/lkml/2007/8/4/39
> Last known good : ?
> Submitter       : Meelis Roos <mroos@linux.ee>
> Caused-By       : ?
> Handled-By      : Rafael J. Wysocki <rjw@sisk.pl>
> Status          : unknown

Is being debugged.

Frankly, I don't know what to think about that.  With the Meelis' .config
SUSPEND_SMP can't even be set ...

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
