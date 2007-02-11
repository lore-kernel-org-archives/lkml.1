Return-Path: <linux-kernel-owner+w=401wt.eu-S1750723AbXBKTt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750723AbXBKTt2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 14:49:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750718AbXBKTt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 14:49:28 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:52064 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750710AbXBKTt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 14:49:27 -0500
X-Sasl-enc: 5WT2zyMQ+hYufjM9IAFV9E80z4cTUYRjH1Jyfc9Eri+O 1171223364
Date: Sun, 11 Feb 2007 17:48:51 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: [GIT PATCH] ACPI patches for 2.6.21
Message-ID: <20070211194851.GB26874@khazad-dum.debian.net>
References: <200702071418.51058.lenb@kernel.org> <20070209230928.GD3949@ucw.cz> <20070210015836.GA24082@khazad-dum.debian.net> <20070211193517.GA15445@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070211193517.GA15445@elf.ucw.cz>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Feb 2007, Pavel Machek wrote:
> > > Not including another /proc/acpi/ibm -like nightmare, is it?
> > 
> > Don't worry, I am already on my way to kill /proc/acpi/ibm... :-)
> 
> Great, thanks!
> 								Pavel

None of the platform/hwmon/led driver model code landed there yet, but it
should be available at:

http://repo.or.cz/w/linux-2.6/linux-acpi-2.6/ibm-acpi-2.6.git queue/waiting

eventually.  Note, I push a lot to that branch, and it is a stgit head, so
it gets rewond if a change that makes sense in an earlier patch shows up.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
