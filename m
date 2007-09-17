Return-Path: <linux-kernel-owner+w=401wt.eu-S1761039AbXIQVSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761039AbXIQVSY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 17:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760886AbXIQVQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 17:16:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51618 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759247AbXIQVP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 17:15:59 -0400
Message-ID: <46EEEE57.6010404@zytor.com>
Date: Mon, 17 Sep 2007 14:15:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Oliver Falk <oliver@linux-kernel.at>
CC: linux-kernel@vger.kernel.org, axp-list@redhat.com,
       Jay Estabrook <jay.estabrook@hp.com>, ac-admin@lists.anotherbloody.com
Subject: Re: 2.6.23 alpha unistd.h changes
References: <46EEE483.4020209@linux-kernel.at>
In-Reply-To: <46EEE483.4020209@linux-kernel.at>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Falk wrote:
> 
> As these additions are quite new to upstream kernel, but at Alphacore we
> have patched it since a while now (I don't know about other Alpha ports;
> Debian folks may speak up now!), I would suggest to use the same
> 'ordering' of the syscalls upstream and add the new syscalls that we had
> not in place, but are now upstream to the end of our 'old' list.
> 

If you want to avoid that in the future, you may want to push your
changes upstream.

	-hpa
