Return-Path: <linux-kernel-owner+w=401wt.eu-S965503AbYD1Pr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965503AbYD1Pr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 11:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935470AbYD1Pk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 11:40:27 -0400
Received: from outbound-mail-36.bluehost.com ([69.89.20.190]:45612 "HELO
	outbound-mail-36.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S935133AbYD1PkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 11:40:24 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Subject: Re: [patch v3] doc: DMA-mapping.txt has undeclared variables [Bug 10397]
Date: Mon, 28 Apr 2008 08:33:37 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       grundler@parisc-linux.org
References: <987999.8753.qm@web52011.mail.re2.yahoo.com>
In-Reply-To: <987999.8753.qm@web52011.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804280833.38130.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 28, 2008 5:58 am Matti Linnanvuori wrote:
> From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
>
> Consistently use pdev as the variable of type struct pci_dev *.
> Update DMA mapping documentation to use 'pdev' rather than 'dev' in
> example code that calls routines expecting 'struct pci_device *', since
> 'dev' might make readers think they're passing 'struct device *'
> parameters. Bug 10397.
>
> Signed-off-by: Matti Linnanvuori <mattilinnanvuori@yahoo.com>

Looks like your mailer or cut & paste corrupted the whitespace in this patch.  
Care to send another as an attachment?

Thanks,
Jesse
