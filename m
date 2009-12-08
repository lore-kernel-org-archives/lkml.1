Return-Path: <linux-kernel-owner+w=401wt.eu-S932300AbZLHPvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300AbZLHPvH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 10:51:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932110AbZLHPvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 10:51:06 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:51094 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135AbZLHPvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 10:51:05 -0500
Date: Tue, 8 Dec 2009 15:51:03 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: Alan Jenkins <sourcejedi.lkml@googlemail.com>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, lenb@kernel.org
Subject: Re: [PATCH] Toshiba Bluetooth enabler (rfkill)
Message-ID: <20091208155103.GA27118@srcf.ucam.org>
References: <4B192D08.9080608@gmail.com> <9b2b86520912080205x478b47eek2377dacdbe44a522@mail.gmail.com> <20091208125530.GA23520@srcf.ucam.org> <4B1E7481.6020902@gmail.com> <20091208154738.GC26435@srcf.ucam.org> <4B1E75AE.5050901@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1E75AE.5050901@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 08, 2009 at 04:50:06PM +0100, Jes Sorensen wrote:

> Understand, not sure how to go about this. It doesn't seem to generate
> an APIC event on off, it just pulls the USB device out of it's plug. Not
> sure if it would be possible to plug into the USB unplug event?

In principle, I guess, but I don't think there's a great deal of 
advantage in it.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
