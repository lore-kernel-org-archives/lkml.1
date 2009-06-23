Return-Path: <linux-kernel-owner+w=401wt.eu-S1755326AbZFWUiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbZFWUiD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 16:38:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754903AbZFWUhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 16:37:53 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57089 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106AbZFWUhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 16:37:52 -0400
Date: Tue, 23 Jun 2009 22:37:44 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Olivier Galibert <galibert@pobox.com>, Greg KH <greg@kroah.com>,
       Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.31-rc0-git: lsusb stopped working?
Message-ID: <20090623203744.GC2045@elf.ucw.cz>
References: <20090623135529.GA2668@elf.ucw.cz> <200906231709.45851.elendil@planet.nl> <20090623161334.GA503@kroah.com> <20090623203518.GA8388@dspnet.fr.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623203518.GA8388@dspnet.fr.eu.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-06-23 22:35:18, Olivier Galibert wrote:
> On Tue, Jun 23, 2009 at 09:13:34AM -0700, Greg KH wrote:
> > If for some reason you can not use the /dev/bus/usb/ device nodes, you
> > can enable the config option by turning on CONFIG_EMBEDDED.
> 
> Wasn't CONFIG_EMBEDDED defined as an option to enable _removing_
> useful stuff normal people do not want to remove?  I for one would
> never imagine going there to put back legacy stuff.

Yes, it surprised me, too.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
