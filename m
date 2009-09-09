Return-Path: <linux-kernel-owner+w=401wt.eu-S1754512AbZIIWOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512AbZIIWOA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 18:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754454AbZIIWN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 18:13:59 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:48058 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159AbZIIWN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 18:13:59 -0400
Date: Wed, 9 Sep 2009 15:14:00 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org, lenb@kernel.org,
       rui.zhang@intel.com, linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH v3] hwmon driver for ACPI 4.0 power meters
Message-ID: <20090909221400.GC10521@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20090820213755.GB10521@tux1.beaverton.ibm.com> <20090821091939.GC21167@elf.ucw.cz> <20090821184718.GD23397@tux1.beaverton.ibm.com> <20090821221705.GA2108@elf.ucw.cz> <20090822011744.GH10521@tux1.beaverton.ibm.com> <20090821140159.GB1328@ucw.cz> <20090908202410.GS10521@tux1.beaverton.ibm.com> <20090909080637.GA28353@elf.ucw.cz> <20090909182051.GA26158@tux1.beaverton.ibm.com> <20090909212752.GA7248@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090909212752.GA7248@elf.ucw.cz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 09, 2009 at 11:27:52PM +0200, Pavel Machek wrote:

> See the archives. Anyway it should be default to N -- it is new driver
> and it is not essential in any way. "default Y" is for features that
> were always in and are now optional.
 
I suppose you have a point--it's not terribly essential.  I've just sent v5
with default N.

--D
