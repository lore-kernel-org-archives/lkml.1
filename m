Return-Path: <linux-kernel-owner+w=401wt.eu-S1755409Ab0AUVwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab0AUVwy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 16:52:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754768Ab0AUVwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 16:52:54 -0500
Received: from bungle.evilgeniuses.org.uk ([195.10.223.155]:49124 "EHLO
	bungle.evilgeniuses.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754654Ab0AUVwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 16:52:53 -0500
X-Greylist: delayed 631 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Jan 2010 16:52:53 EST
Subject: Re: [PATCH] Disable i8042 checks on Intel Apple Macs
From: Bastien Nocera <hadess@hadess.net>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, pjones@redhat.com
In-Reply-To: <51f3faa71001211339t4652700ct34659c37479cd67e@mail.gmail.com>
References: <1264011793.1735.3683.camel@localhost.localdomain>
	 <4B57A2D4.9030204@gmail.com>
	 <20100121185544.GB11996@core.coreip.homeip.net>
	 <51f3faa71001211339t4652700ct34659c37479cd67e@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Jan 2010 21:42:20 +0000
Message-ID: <1264110140.26176.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-21 at 15:39 -0600, Robert Hancock wrote:
<snip>
> Macs will be tested with Windows too, so obviously it manages to avoid
> this problem somehow, and I very much doubt it has an Apple-specific
> check..

Only the bootcamp-provided BIOS will be tested, not the stock one. This
patch covers both types of BIOSes.

