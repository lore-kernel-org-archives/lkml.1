Return-Path: <linux-kernel-owner+w=401wt.eu-S1760884AbYBYXGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760884AbYBYXGd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 18:06:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755509AbYBYXGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 18:06:14 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:32809 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754787AbYBYXGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 18:06:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: 2.6.25-rc2 Regression Thinkpad acpi
Date: Tue, 26 Feb 2008 00:05:01 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Lukas Hejtmanek <xhejtman@ics.muni.cz>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
References: <20080225093914.GB4375@ics.muni.cz> <20080225220720.GA4523@ics.muni.cz> <20080225230035.GA14503@khazad-dum.debian.net>
In-Reply-To: <20080225230035.GA14503@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802260005.02613.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 26 of February 2008, Henrique de Moraes Holschuh wrote:
> On Mon, 25 Feb 2008, Lukas Hejtmanek wrote:
> > volume keys work. But anything through acpid does not. Even AC/battery switch
> > is not signalized. So the bug may be somewhere else?
> 
> Yeah, there is an EC-related regression in 2.6.25-rc3 that bites your
> thinkpad.  I don't have a link to it right now, but if you look for the
> messages to LKML on the last 48h, you will find it.

http://bugzilla.kernel.org/show_bug.cgi?id=10100

(easy to remember ;=))

Thanks,
Rafael
