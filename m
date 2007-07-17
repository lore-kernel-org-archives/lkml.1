Return-Path: <linux-kernel-owner+w=401wt.eu-S937005AbXGQVE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937005AbXGQVE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 17:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760832AbXGQVEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 17:04:24 -0400
Received: from khc.piap.pl ([195.187.100.11]:53703 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764070AbXGQVEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 17:04:22 -0400
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: William Montgomery <william@opinicus.com>, linux-kernel@vger.kernel.org
Subject: Re: e100 PCI bridge problem
References: <4697B85B.4040902@opinicus.com>
	<m33azrt5a6.fsf@maximus.localdomain> <46995998.70706@opinicus.com>
	<m3d4yuczqw.fsf@maximus.localdomain> <469D0A81.3000001@opinicus.com>
	<469D1093.9070801@intel.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 17 Jul 2007 23:04:19 +0200
In-Reply-To: <469D1093.9070801@intel.com> (Auke Kok's message of "Tue, 17 Jul 2007 11:55:15 -0700")
Message-ID: <m3644ivj1o.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Kok, Auke" <auke-jan.h.kok@intel.com> writes:

> PERR+ set... not good - this certainly will cause major issues

Unfortunately some devices assert PERR without a good reason,
and it may do no special harm.

Should be handled and cleared, probably.
-- 
Krzysztof Halasa
