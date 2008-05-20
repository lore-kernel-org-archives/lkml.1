Return-Path: <linux-kernel-owner+w=401wt.eu-S1763089AbYETRyH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763089AbYETRyH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 13:54:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756022AbYETRxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 13:53:51 -0400
Received: from outbound-mail-09.bluehost.com ([69.89.17.209]:60360 "HELO
	outbound-mail-09.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754700AbYETRxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 13:53:50 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: tcamuso@redhat.com
Subject: Re: [PATCH] PCI: Correct last two HP entries in the bfsort whitelist
Date: Tue, 20 May 2008 10:53:43 -0700
User-Agent: KMail/1.9.9
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org,
       "Schoeller, Patrick (Linux - Houston, TX)" <Patrick.Schoeller@hp.com>
References: <482C838E.3030203@redhat.com> <200805161029.55649.jbarnes@virtuousgeek.org> <482DE5F1.2080303@redhat.com>
In-Reply-To: <482DE5F1.2080303@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805201053.43917.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 16, 2008 12:52 pm Tony Camuso wrote:
> I would like to add that HP has tested the patch, and our risk
> assessment shows more benefit for HP ProLiant customers than the
> possible adverse affects.
>
> Since this patch only affects the two HP ProLiant platforms listed, and
> since HP is willing to take ownership for any problems related to the
> patch, we would like to see it ACK'd and added to the current 2.6.26
> kernel.

I just sent Linus the pull request for this fix; should be upstream soon.

Thanks,
Jesse
