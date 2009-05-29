Return-Path: <linux-kernel-owner+w=401wt.eu-S1757820AbZE2Jbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757820AbZE2Jbd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 05:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757161AbZE2Jb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 05:31:26 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:59530 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756116AbZE2Jb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 05:31:26 -0400
Date: Fri, 29 May 2009 10:31:26 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, mingo@elte.hu
Subject: Re: EeePC 900 trackpad often not detected at boot in 2.6.30-rc4
Message-ID: <20090529093126.GA30979@sucs.org>
References: <20090511072135.GA4682@sucs.org> <20090520024658.GD17649@dtor-d630.eng.vmware.com> <20090520054739.GA31552@sucs.org> <200905200025.20280.dmitry.torokhov@gmail.com> <20090526222049.GB27961@sucs.org> <20090528155401.GB18589@dtor-d630.eng.vmware.com> <20090528164231.GA19324@sucs.org> <20090528164942.GC18589@dtor-d630.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090528164942.GC18589@dtor-d630.eng.vmware.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 09:49:43AM -0700, Dmitry Torokhov wrote:
> On Thu, May 28, 2009 at 05:42:31PM +0100, Sitsofe Wheeler wrote:
> > On a normal boot there will be exactly 115 interrupts if the trackpad
> > hasn't been touched but everything is OK just after booting. If there
> > are less interrupts you know something has gone wrong...
> > 
> 
> OK, I guess I will be pushin this to Linus then... Thank you for
> testing.

Should I be trying to get you some extra logs (I saw and replied to
Ingo's mail)?  If no one else has this problem is this just a symptom of
a bigger problem (i.e. broken scheduling or unstated assumptions)?

-- 
Sitsofe | http://sucs.org/~sits/
