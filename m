Return-Path: <linux-kernel-owner+w=401wt.eu-S1751837AbYJaN2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837AbYJaN2e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 09:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750790AbYJaN2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 09:28:24 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:38229 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbYJaN2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 09:28:24 -0400
Date: Fri, 31 Oct 2008 13:28:21 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Daniel Perzynski <daniel.perzynski@gmail.com>
Cc: linu-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       carlos@strangeworlds.co.uk
Subject: Re: HP WMI laptop extras driver
Message-ID: <20081031132821.GA5795@srcf.ucam.org>
References: <28f715610810310624m67b86d10t76b21b2cbbf2a8ac@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28f715610810310624m67b86d10t76b21b2cbbf2a8ac@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 02:24:44PM +0100, Daniel Perzynski wrote:

> I have HP Pavilion HDX9494nr. That laptop has many additional keys like CD
> Eject, Treble and Bass regulation, Quick Play section (DVD,TV,Quick Play). When
> I'm pressing those buttons (after loading hp-wmi driver) I see in kernel
> messages that I've pressed a key with the code xxxxxx. How can I map those
> events to actions (for example pressing CD Eject I would like to map to unmount
> /dev/cdrom command). Do we need to add my key codes to hp-wmi.c program or
> there is another program which can translate those key codes to actions?   

Can you include the exact messages that you get when pressing each 
button?

Thanks,
-- 
Matthew Garrett | mjg59@srcf.ucam.org
