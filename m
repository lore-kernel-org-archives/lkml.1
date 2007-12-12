Return-Path: <linux-kernel-owner+w=401wt.eu-S1758821AbXLLLAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758821AbXLLLAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 06:00:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757415AbXLLLAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 06:00:07 -0500
Received: from mxintern.schlund.de ([212.227.126.201]:61535 "EHLO
	mxintern.schlund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071AbXLLLAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 06:00:05 -0500
Date: Wed, 12 Dec 2007 11:58:41 +0100
From: Anders Henke <anders.henke@1und1.de>
To: miquels@cistron.nl, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, matthew@wil.cx, akpm@linux-foundation.org
Subject: Re: broken dpt_i2o in 2.6.23 (was: ext2 check page: bad entry in directory) (fwd)
Message-ID: <20071212105841.GN6770@1und1.de>
Mail-Followup-To: Anders Henke <anders.henke@1und1.de>, miquels@cistron.nl,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
	matthew@wil.cx, akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: 1&1 Internet AG
User-Agent: Mutt/1.5.13 (2006-08-11)
X-UI-Msg-Verification: 7a0d619491ecb39cc91cb9d567768563
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'd like to let you now that my boxes are running a 32-bit kernel, so
the 64-bit-uncleanliness shouldn't apply to my boxes; however,

http://www.miquels.cistron.nl/linux/dpt_i2o-64bit-2.6.23.patch

fixed the issue on my testbox.

I took a clean 2.6.23, applied patch, recompiled the kernel, reboot: works.



Regards,

Anders

PS: Sorry for breaking the threading, I'm not a regular subscriber to
linux-kernel and haven't received Miguel's message by mail.
-- 
1&1 Internet AG              System Design
Brauerstrasse 48             v://49.721.91374.50
D-76135 Karlsruhe            f://49.721.91374.225

Amtsgericht Montabaur HRB 6484
Vorstand: Henning Ahlert, Ralph Dommermuth, Matthias Ehrlich, Andreas Gauger,
Thomas Gottschlich, Matthias Greve, Robert Hoffmann, Norbert Lang, Achim Weiss
Aufsichtsratsvorsitzender: Michael Scheeren
