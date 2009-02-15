Return-Path: <linux-kernel-owner+w=401wt.eu-S1754808AbZBONBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbZBONBf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 08:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbZBONB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 08:01:27 -0500
Received: from relay4-v.mail.gandi.net ([217.70.178.78]:47904 "EHLO
	relay4-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191AbZBONB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 08:01:26 -0500
Date: Sun, 15 Feb 2009 14:01:24 +0100
From: Mathieu Chouquet-Stringer <mchouque@free.fr>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: ibm-acpi@hmh.eng.br, ibm-acpi-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATH] No Thinkpad Module Autoloading On T30
Message-ID: <20090215130123.GA19264@mobydick>
Mail-Followup-To: Mathieu Chouquet-Stringer <mchouque@free.fr>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>, ibm-acpi@hmh.eng.br,
	ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20090214223407.GA3367@mobydick> <20090215125915.GC7660@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090215125915.GC7660@khazad-dum.debian.net>
X-Face: %JOeya=Dg!}[/#Go&*&cQ+)){p1c8}u\Fg2Q3&)kothIq|JnWoVzJtCFo~4X<uJ\9cHK
	'.w 3:{EoxBR
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 15, 2009 at 09:59:15AM -0300, Henrique de Moraes Holschuh wrote:
> I will:
> 1. retitle the patch to "thinkpad-acpi: fix module autoloading on older models"
> 2. add the cc for stable@kernel.org
> 2. queue it to make sure it won't get lost
> 3. check if Len would take it for 2.6.29 since it is a simple, obvious fix.
> If not, it will go in during the 2.6.30 merge window.  After it gets into
> mainline, it will go to the stable trees.
> 
> Thank you.

Works for me!  Thanks much.
-- 
Mathieu Chouquet-Stringer                           mchouque@free.fr
            The sun itself sees not till heaven clears.
	             -- William Shakespeare --
