Return-Path: <linux-kernel-owner+w=401wt.eu-S1757037AbYFWINX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037AbYFWINX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 04:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbYFWINN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 04:13:13 -0400
Received: from isilmar.linta.de ([213.133.102.198]:55351 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751953AbYFWINL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 04:13:11 -0400
Date: Mon, 23 Jun 2008 10:13:09 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Pavel Machek <pavel@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pcmcia@lists.infradead.org
Subject: Re: 2.6.26-rc6: pcmcia stopped working after resume
Message-ID: <20080623081309.GA10820@isilmar.linta.de>
Mail-Followup-To: Pavel Machek <pavel@suse.cz>,
	kernel list <linux-kernel@vger.kernel.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, linux-pcmcia@lists.infradead.org
References: <20080622224022.GA2066@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080622224022.GA2066@elf.ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jun 23, 2008 at 12:40:22AM +0200, Pavel Machek wrote:
> After s2ram and resume, CF card in PCMCIA-to-CF slot is no longer
> detected.

might this be related to:
http://bugzilla.kernel.org/show_bug.cgi?id=10957 ? There didn't change
anything with regard to pcmcia between -rc3 and -rc6...

Best,
	Dominik
