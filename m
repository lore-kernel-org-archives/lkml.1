Return-Path: <linux-kernel-owner+w=401wt.eu-S965695AbXJPU41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965695AbXJPU41 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 16:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934231AbXJPU4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 16:56:17 -0400
Received: from cavan.codon.org.uk ([78.32.9.130]:47943 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760881AbXJPU4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 16:56:16 -0400
Date: Tue, 16 Oct 2007 21:55:53 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Jeremy Katz <katzj@redhat.com>, linux-kernel@vger.kernel.org,
       davej@redhat.com
Message-ID: <20071016205553.GA28531@srcf.ucam.org>
References: <20071016130053.GA20010@srcf.ucam.org> <20071016141153.GA3237@khazad-dum.debian.net> <20071016142121.GA21431@srcf.ucam.org> <20071016143124.GB3237@khazad-dum.debian.net> <20071016144016.GA21749@srcf.ucam.org> <20071016165623.GA13643@khazad-dum.debian.net> <20071016184606.GB25181@srcf.ucam.org> <alpine.LFD.0.999.0710161208340.6887@woody.linux-foundation.org> <d120d5000710161312r5676cad8o60e0790a4e8d5256@mail.gmail.com> <471523B6.7030506@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471523B6.7030506@intel.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] Map volume and brightness events on thinkpads
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2007 at 01:48:54PM -0700, Kok, Auke wrote:

> real life example: hook up one of those fancy usb keyboards with volume buttons to
> your thinkpad. The volume keys on the thinkpad do adjust the volume, the ones on
> the USB keyboard do not - software needs to be able to distinguish between them,
> and sane defaults for these events need to not overlap.

That's not a problem - they'll be coming from different input devices.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
