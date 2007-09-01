Return-Path: <linux-kernel-owner+w=401wt.eu-S1752884AbXIAKdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbXIAKdo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 06:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753167AbXIAKdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 06:33:21 -0400
Received: from mail.suse.de ([195.135.220.2]:56510 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884AbXIAKdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 06:33:18 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Daniel Walker <dwalker@mvista.com>
Subject: Re: nmi_watchdog=2 regression in 2.6.21
Date: Sat, 1 Sep 2007 12:19:49 +0200
User-Agent: KMail/1.9.6
Cc: =?utf-8?q?Bj=C3=B6rn_Steinbrink?= <B.Steinbrink@gmx.de>,
       eranian@hpl.hp.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <20070828194636.GB2814@frankl.hpl.hp.com> <20070901010053.GA29765@atjola.homenet> <1188610568.9476.7.camel@dhcp193.mvista.com>
In-Reply-To: <1188610568.9476.7.camel@dhcp193.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709011219.49256.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I'm satisfied that Stephane's last patch fixes it ..

Great. Can someone send a final version with proper Changelog and Signed-off-by 
please? Thanks.

-Andi
