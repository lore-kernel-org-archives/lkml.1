Return-Path: <linux-kernel-owner+w=401wt.eu-S1161105AbXBGJ6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161105AbXBGJ6m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 04:58:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161098AbXBGJ6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 04:58:42 -0500
Received: from cavan.codon.org.uk ([217.147.92.49]:50811 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161105AbXBGJ6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 04:58:41 -0500
Date: Wed, 7 Feb 2007 09:58:07 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Michael Leun <ml@newton.leun.net>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, mitr@volny.cz,
       linux-kernel@vger.kernel.org
Message-ID: <20070207095807.GA15088@srcf.ucam.org>
References: <20070205103521.0f20779d@xenia.leun.net> <20070205110529.0e4ae6c0@xenia.leun.net> <d120d5000702060837j7382d429ned3fb5a5e47ac76b@mail.gmail.com> <20070206194318.1d8e1fc0@xenia.leun.net> <20070206200748.GA24176@srcf.ucam.org> <20070207072347.7b30781d@xenia.leun.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070207072347.7b30781d@xenia.leun.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] wistron button support for fujitsu-siemens Amilo D88x0
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 07, 2007 at 07:23:47AM +0100, Michael Leun wrote:
> On Tue, 6 Feb 2007 20:07:49 +0000
> Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > Hm. Is there really no PNP id that tends to be associated with this 
> > wistron hardware? Fujitsu (at least) seem to be quite good at
> > exposing a lot of their magic hardware that way.
> 
> Sorry, I do not know and I do not know how to find out. If there is any
> testing I should do on my machine I will happily do that, but you would
> have to tell me what to do.

cat /sys/bus/pnp/devices/*/id should give a list of the available IDs.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
