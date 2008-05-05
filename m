Return-Path: <linux-kernel-owner+w=401wt.eu-S1757428AbYEEPA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbYEEPA6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 11:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753724AbYEEPAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 11:00:47 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:10680 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbYEEPAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 11:00:46 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: PNP: set IRQ index in sysfs "set irq" interface
Date: Mon, 5 May 2008 09:00:45 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Adam M Belay <abelay@mit.edu>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200805011539.58705.bjorn.helgaas@hp.com> <481DBE81.8000608@keyaccess.nl>
In-Reply-To: <481DBE81.8000608@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805050900.46521.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 May 2008 07:47:45 am Rene Herman wrote:
> But what I wanted to ask -- judging from my .gitconfig (as opposed to my 
> memory) I haven't done anything special to get the -p (--show-c-function) 
> functionality from git-diff. Do you do anything special to not get it? It 
> really helps when looking at patches.

I agree, "--show-c-function" is often handy.  I use quilt, and it
looks like it doesn't add that option by default.  I added a ~/.quiltrc
containing 'QUILT_DIFF_OPTS="-p"', and it looks like that will do the
trick.  Thanks for the tip.

Bjorn

