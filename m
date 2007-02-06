Return-Path: <linux-kernel-owner+w=401wt.eu-S965397AbXBFUId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965397AbXBFUId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 15:08:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965406AbXBFUId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 15:08:33 -0500
Received: from cavan.codon.org.uk ([217.147.92.49]:57559 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965397AbXBFUIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 15:08:32 -0500
Date: Tue, 6 Feb 2007 20:07:49 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Michael Leun <ml@newton.leun.net>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, mitr@volny.cz,
       linux-kernel@vger.kernel.org
Message-ID: <20070206200748.GA24176@srcf.ucam.org>
References: <20070205103521.0f20779d@xenia.leun.net> <20070205110529.0e4ae6c0@xenia.leun.net> <d120d5000702060837j7382d429ned3fb5a5e47ac76b@mail.gmail.com> <20070206194318.1d8e1fc0@xenia.leun.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070206194318.1d8e1fc0@xenia.leun.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] wistron button support for fujitsu-siemens Amilo D88x0
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 06, 2007 at 07:43:18PM +0100, Michael Leun wrote:

> Wistron button support for fujitsu-siemens Amilo D88x0 - works just fine
> for me on a Amilo D8820. 

Hm. Is there really no PNP id that tends to be associated with this 
wistron hardware? Fujitsu (at least) seem to be quite good at exposing a 
lot of their magic hardware that way.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
