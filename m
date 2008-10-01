Return-Path: <linux-kernel-owner+w=401wt.eu-S1753448AbYJAJyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbYJAJyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 05:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbYJAJyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 05:54:10 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:40031 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbYJAJyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 05:54:09 -0400
Date: Wed, 1 Oct 2008 10:54:03 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Pavel Machek <pavel@suse.cz>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       carbonated beverage <ramune@net-ronin.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Thinkpad brightness keys kill X on 2.6.26.5
Message-ID: <20081001095403.GB27987@srcf.ucam.org>
References: <20080925060244.GA18945@net-ronin.org> <20080930231952.GB15903@ucw.cz> <48E2CB5A.1050809@goop.org> <20081001094041.GB897@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081001094041.GB897@elf.ucw.cz>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2008 at 11:40:41AM +0200, Pavel Machek wrote:

> What are you using for s2ram? s2ram -f -a 3 normally works on thinkpads...

Fedora doesn't use s2ram, and at this point passing any s2ram flags on 
Intel graphics is just covering up kernel bugs.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
