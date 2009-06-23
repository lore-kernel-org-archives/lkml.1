Return-Path: <linux-kernel-owner+w=401wt.eu-S1755551AbZFWUf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbZFWUf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 16:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbZFWUfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 16:35:18 -0400
Received: from dspnet.fr.eu.org ([213.186.44.138]:3743 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365AbZFWUfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 16:35:17 -0400
Date: Tue, 23 Jun 2009 22:35:18 +0200
From: Olivier Galibert <galibert@pobox.com>
To: Greg KH <greg@kroah.com>
Cc: Frans Pop <elendil@planet.nl>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.31-rc0-git: lsusb stopped working?
Message-ID: <20090623203518.GA8388@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Greg KH <greg@kroah.com>, Frans Pop <elendil@planet.nl>,
	Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
References: <20090623135529.GA2668@elf.ucw.cz> <200906231709.45851.elendil@planet.nl> <20090623161334.GA503@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623161334.GA503@kroah.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 09:13:34AM -0700, Greg KH wrote:
> If for some reason you can not use the /dev/bus/usb/ device nodes, you
> can enable the config option by turning on CONFIG_EMBEDDED.

Wasn't CONFIG_EMBEDDED defined as an option to enable _removing_
useful stuff normal people do not want to remove?  I for one would
never imagine going there to put back legacy stuff.

  OG.
