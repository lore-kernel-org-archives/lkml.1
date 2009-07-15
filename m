Return-Path: <linux-kernel-owner+w=401wt.eu-S1754204AbZGOLbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbZGOLbO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 07:31:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbZGOLbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 07:31:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60729 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753922AbZGOLbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 07:31:13 -0400
Date: Wed, 15 Jul 2009 13:31:12 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Possible Suspend to Ram bug?
In-Reply-To: <200907150359.12187.tfjellstrom@shaw.ca>
Message-ID: <alpine.LNX.2.00.0907151330180.813@wotan.suse.de>
References: <200907100458.27410.tfjellstrom@shaw.ca> <200907140417.12847.tfjellstrom@shaw.ca> <alpine.LRH.2.00.0907141752580.27150@twin.jikos.cz> <200907150359.12187.tfjellstrom@shaw.ca>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jul 2009, Thomas Fjellstrom wrote:

> I'll try with debian's 2.6.30 first. But there's a small issue with 
> that, .30 and .31 seem to have some performance regressions according to 
> sites like phoronix.

You know, there are lies, then horrible lies, then benchmarks, and 
benchmarks done wrong.

Just do your own measurements under your particular workload, and if you 
see any performance regression, just report it.

-- 
Jiri Kosina
SUSE Labs
