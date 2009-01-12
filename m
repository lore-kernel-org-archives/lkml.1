Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbZALMHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbZALMHf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 07:07:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbZALMHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 07:07:22 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1212 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbZALMHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 07:07:21 -0500
Date: Mon, 12 Jan 2009 11:48:19 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Network device with variable hard header len
Message-ID: <20090112114817.GB32299@sirena.org.uk>
References: <20090110112812.GA8393@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090110112812.GA8393@doriath.ww600.siemens.net>
X-Cookie: Eschew obfuscation.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2009 at 02:28:12PM +0300, Dmitry Eremin-Solenikov wrote:

> Sorry if this a dumb question. Currently I'm programming a driver for
> the devices with variable network header len. From the Linux net stack
> perspective what should I do: set netdev->hard_header_len to maximum
> possible header and use less space that specified there or set
> netdev->needed_headroom to that value?

> If that metters, I'll be implementing my own set of header_ops in any
> case.

This is probably better asked on netdev (CCed).
