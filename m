Return-Path: <linux-kernel-owner+w=401wt.eu-S932101AbZGOAeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101AbZGOAeO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 20:34:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756815AbZGOAeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 20:34:14 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:56294 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756703AbZGOAeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 20:34:13 -0400
Date: Tue, 14 Jul 2009 17:32:08 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: lenb@kernel.org, davej@redhat.com, Matthew Garrett <mjg59@srcf.ucam.org>,
       Thomas Renninger <trenn@suse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2] acpi: Fix regression where _PPC is not read at boot
	even when ignore_ppc=0
Message-ID: <20090715003207.GA5111@plum>
Reply-To: djwong@us.ibm.com
References: <20090428195348.GA8376@srcf.ucam.org> <20090429213930.GE6968@plum> <20090429220037.GA8604@srcf.ucam.org> <20090430072556.GD16737@elte.hu> <20090430095414.GA19462@srcf.ucam.org> <20090430111042.GA12809@elte.hu> <20090430111338.GA21297@srcf.ucam.org> <20090515191219.GH6968@plum> <20090602232108.GG7917@plum> <20090607100541.GJ31286@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090607100541.GJ31286@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 07, 2009 at 12:05:41PM +0200, Ingo Molnar wrote:

> I see no problems on that system here, with the patch below applied. 
> So, as i indicated above, feel free to pursue this angle, there's no 
> objection from me.

Hmm... the patch hasn't gone in to Linus' tree yet, nor has anyone else NAK'd
it.  I assume it's either Len Brown (ACPI) or Dave Jones (cpufreq) who ought to
pick it up?

--D
