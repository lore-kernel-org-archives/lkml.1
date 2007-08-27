Return-Path: <linux-kernel-owner+w=401wt.eu-S1754575AbXH0XQD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbXH0XQD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 19:16:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbXH0XPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 19:15:51 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:58495 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbXH0XPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 19:15:50 -0400
Subject: Re: nmi_watchdog=2 regression in 2.6.21
From: Daniel Walker <dwalker@mvista.com>
To: eranian@hpl.hp.com
Cc: =?ISO-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>, ak@suse.de,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20070827225555.GI784@frankl.hpl.hp.com>
References: <1186531609.22044.50.camel@imap.mvista.com>
	 <20070808142059.GF30805@atjola.homenet>
	 <20070827175431.GD784@frankl.hpl.hp.com>
	 <1188237331.2435.255.camel@dhcp193.mvista.com>
	 <20070827225555.GI784@frankl.hpl.hp.com>
Content-Type: text/plain
Date: Mon, 27 Aug 2007 16:07:54 -0700
Message-Id: <1188256074.2435.272.camel@dhcp193.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-27 at 15:55 -0700, Stephane Eranian wrote:

> Yet the model name looks strange. So we need to run one more test,
> as the fam/model is not enough. What we need to check is whether or
> not this processor implements architectural perfmon or not.
> 
> Could you please compile and run the attached program and send me 
> the output?

The output below is all the output ..

eax=0x7280201: version=1  num_cnt=2

Daniel

