Return-Path: <linux-kernel-owner+w=401wt.eu-S932323AbYBMJG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323AbYBMJG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 04:06:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932251AbYBMJF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 04:05:27 -0500
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:16503 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932238AbYBMJFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 04:05:17 -0500
Message-ID: <47B2B268.1070702@panasas.com>
Date: Wed, 13 Feb 2008 11:03:36 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Stefan Priebe - allied internet ag <s.priebe@allied-internet.ag>
CC: =?ISO-8859-15?Q?Sven_K=F6hler?= <skoehler@upb.de>,
       Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-kernel@vger.kernel.org, Joerg Dorchain <joerg@dorchain.net>,
       Jon Chelton <jchelton@ffpglobal.com>
Subject: Re: [BUGFIX 2/2] gdth: bugfix for the Timer at exit crash
References: <fnqka6$l46$1@ger.gmane.org> <47A19E26.30107@panasas.com> <47B1D7A8.8010108@panasas.com> <47B1DA2A.1060904@panasas.com> <47B29702.7050503@allied-internet.ag>
In-Reply-To: <47B29702.7050503@allied-internet.ag>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Feb 2008 09:03:49.0494 (UTC) FILETIME=[58EBA960:01C86E1F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13 2008 at 9:06 +0200, Stefan Priebe - allied internet ag <s.priebe@allied-internet.ag> wrote:
> Hello!
> 
> I've tested this patch now - and it works fine. Now rmmod, halt and 
> reboot also works.
> 
> Stefan Priebe
> 
This is grate news Stefan. Thank you very much for all your time
and effort, with out we could not have fixed all this.

Boaz
