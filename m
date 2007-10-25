Return-Path: <linux-kernel-owner+w=401wt.eu-S1758379AbXJYC3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379AbXJYC3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 22:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754144AbXJYC3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 22:29:10 -0400
Received: from emerald.lightlink.com ([205.232.34.14]:18573 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564AbXJYC3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 22:29:08 -0400
Date: Wed, 24 Oct 2007 22:25:29 -0400
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: Riku Voipio <riku.voipio@iki.fi>
Cc: Jean Delvare <khali@linux-fr.org>, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] hwmon/f75375s.c: buggy if()
Message-ID: <20071025022529.GF30546@jupiter.solarsys.private>
References: <20071017195439.GD3778@stusta.de> <20071017204508.GA32110@kos.to> <20071018133744.GC3526@jupiter.solarsys.private> <20071019143754.0aa4483b@hyperion.delvare> <20071024115034.GA5797@kos.to>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024115034.GA5797@kos.to>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Riku:

* Riku Voipio <riku.voipio@iki.fi> [2007-10-24 14:50:34 +0300]:
> On Fri, Oct 19, 2007 at 02:37:54PM +0200, Jean Delvare wrote:
> > Riku, can you please submit a patch fixing this? The attribute should
> > be declared read-only, and then you can use sysfs_chmod_file() to
> > change it to read-write where supported. 
> 
> Thanks, this was good suggestion. Patch attached.

No patch?

-- 
Mark M. Hoffman
mhoffman@lightlink.com

