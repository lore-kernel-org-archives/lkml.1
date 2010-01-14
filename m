Return-Path: <linux-kernel-owner+w=401wt.eu-S1753065Ab0ANWFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab0ANWFs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:05:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920Ab0ANWFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:05:47 -0500
Received: from cantor.suse.de ([195.135.220.2]:56349 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259Ab0ANWFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:05:46 -0500
Date: Thu, 14 Jan 2010 23:05:43 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>, linux-kernel@vger.kernel.org,
       felipe.balbi@nokia.com, Pavel Machek <pavel@ucw.cz>,
       linux-fbdev@vger.kernel.org, krzysztof.h1@wp.pl,
       Andrew Morton <akpm@linux-foundation.org>, linux-usb@vger.kernel.org,
       Oliver Neukum <oliver@neukum.org>, linux-input@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: Best way to post Logitech G13 driver 0.0.4?
In-Reply-To: <fbd89f64a86fc72184658fe9b27509f3.squirrel@intranet.cs.nmsu.edu>
Message-ID: <alpine.LNX.2.00.1001142305010.30977@pobox.suse.cz>
References: <201001071623.o07GNOB4022157@mustang.cs.nmsu.edu>    <45a44e481001071832q40d6f913w2ccf89c4c45a692a@mail.gmail.com>    <5370b38ca0c149470c0e364627c56ee4.squirrel@intranet.cs.nmsu.edu>    <alpine.LNX.2.00.1001091441180.7275@pobox.suse.cz>   
 <cf0603d7c734f836f0b4a64815d649ae.squirrel@intranet.cs.nmsu.edu> <fbd89f64a86fc72184658fe9b27509f3.squirrel@intranet.cs.nmsu.edu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jan 2010, Rick L. Vinyard, Jr. wrote:

> What would be the best way to post 0.0.4 of the driver; as a diff against
> the previous 0.0.3 patch to emphasize the changes or as a diff against the
> torvalds tree to show the patch in its entirety?

Diff against current Linus' tree (or linux-next tree) is much preferred 
over any other options.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
