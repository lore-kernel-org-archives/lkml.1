Return-Path: <linux-kernel-owner+w=401wt.eu-S1757460AbZEVTfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460AbZEVTfk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 15:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757151AbZEVTfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 15:35:33 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:41639 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756924AbZEVTfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 15:35:33 -0400
Date: Fri, 22 May 2009 21:35:34 +0200
From: Andreas Mohr <andi@lisas.de>
To: Borislav Petkov <petkovbb@gmail.com>, Andreas Mohr <andi@lisas.de>,
       Pavel Machek <pavel@ucw.cz>, Peter Feuerer <peter@piie.net>,
       LKML <linux-kernel@vger.kernel.org>, lenb@kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [PATCH] Acer Aspire One Fan Contro
Message-ID: <20090522193534.GA16384@rhlx01.hs-esslingen.de>
References: <20090522140930.GA26580@elf.ucw.cz> <20090522161009.GA20476@rhlx01.hs-esslingen.de> <20090522182402.GA23618@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090522182402.GA23618@liondog.tnic>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 22, 2009 at 08:24:02PM +0200, Borislav Petkov wrote:
> What are your settings now?

# cat /etc/acerfand.conf
INTERVAL=5
FANOFF=59
FANAUTO=69

Andreas Mohr
