Return-Path: <linux-kernel-owner+w=401wt.eu-S1755964AbYKEJyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbYKEJyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 04:54:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750812AbYKEJyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 04:54:37 -0500
Received: from styx.suse.cz ([82.119.242.94]:39566 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750754AbYKEJyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 04:54:36 -0500
Subject: RE: [PATCH V2 0/2] enable irqs when waiting for rwlocks
From: Petr Tesarik <ptesarik@suse.cz>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Robin Holt <holt@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA35BE0554D@orsmsx505.amr.corp.intel.com>
References: <1224777451.11530.52.camel@elijah.suse.cz>
	 <1225443142.6825.4.camel@elijah.suse.cz>
	 <57C9024A16AD2D4C97DC78E552063EA35A7ED9D3@orsmsx505.amr.corp.intel.com>
	 <20081103114638.GD8483@sgi.com>
	 <57C9024A16AD2D4C97DC78E552063EA35BE0554D@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain
Organization: SUSE LINUX
Date: Wed, 05 Nov 2008 10:54:33 +0100
Message-Id: <1225878873.3033.1.camel@elijah.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-03 at 13:47 -0800, Luck, Tony wrote:
> > Just a few years of experiencal evidence.  The equivalent of this patch
> > has been in the SuSE SLES10 kernel for years and not been detected as
> > being negative.
> 
> That's good to know.
> 
> Petr: I tried to apply these ... but the patches seem corrupted
> (leading spaces dropped? ... I checked in the marc.info archive
> and they seem broken there too).  Can you regenerate them and
> repost (attachments are ok).

Oops. Interesting.

Anyway, I can see that Robin Holt has already regenerated the patches
against the latest directory structure, so I assume there's nothing more
to be done.

Petr

