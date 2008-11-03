Return-Path: <linux-kernel-owner+w=401wt.eu-S1756640AbYKCPJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640AbYKCPJQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 10:09:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756381AbYKCPIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 10:08:50 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:37855 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756353AbYKCPIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 10:08:49 -0500
Date: Mon, 3 Nov 2008 15:08:43 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux acpi <linux-acpi@vger.kernel.org>
Subject: Re: eeepc-laptop rfkill, stupid question #4
Message-ID: <20081103150843.GA1107@srcf.ucam.org>
References: <490B70A3.8010108@tuffmail.co.uk> <20081102040008.GB29606@khazad-dum.debian.net> <490D8C4E.3010201@tuffmail.co.uk> <20081102130655.GA12766@srcf.ucam.org> <20081103141628.GB31078@khazad-dum.debian.net> <20081103141836.GA31894@srcf.ucam.org> <490F0ACC.4000808@tuffmail.co.uk> <20081103145145.GD31078@khazad-dum.debian.net> <20081103145543.GA496@srcf.ucam.org> <20081103150229.GF31078@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081103150229.GF31078@khazad-dum.debian.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2008 at 01:02:29PM -0200, Henrique de Moraes Holschuh wrote:

> Right now, you should still rfkill_force_state().  Please wait for an hour
> or two while I clean up that broken resume handling, and I will tell you for
> sure.

Cool. I'll hold off posting my cleanups until then in that case.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
