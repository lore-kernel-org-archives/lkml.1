Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933477Ab0BPW0i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 17:26:38 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:47106 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933260Ab0BPW0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 17:26:36 -0500
Date: Tue, 16 Feb 2010 14:26:11 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, lenb@kernel.org, davej@redhat.com,
       Thomas Renninger <trenn@suse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2] acpi: Fix regression where _PPC is not read at boot
	even when ignore_ppc=0
Message-ID: <20100216222611.GP29569@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20090429220037.GA8604@srcf.ucam.org> <20090430072556.GD16737@elte.hu> <20090430095414.GA19462@srcf.ucam.org> <20090430111042.GA12809@elte.hu> <20090430111338.GA21297@srcf.ucam.org> <20090515191219.GH6968@plum> <20090602232108.GG7917@plum> <20090607100541.GJ31286@elte.hu> <20090715003207.GA5111@plum> <20100216220707.GA5966@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100216220707.GA5966@srcf.ucam.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 16, 2010 at 10:07:07PM +0000, Matthew Garrett wrote:
> Did this ever get picked up?

Nope.  I vaguely recall asking a few times if there were any objections left,
but there weren't any, and I think Len or someone said it looked good back at
LPC last summer.  Does not appear in 2.6.33-rc8 though.

--D
