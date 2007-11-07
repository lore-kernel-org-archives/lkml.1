Return-Path: <linux-kernel-owner+w=401wt.eu-S1759417AbXKGSv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759417AbXKGSv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 13:51:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752460AbXKGSvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 13:51:48 -0500
Received: from mail-gw3.adaptec.com ([162.62.93.58]:56881 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbXKGSvr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 13:51:47 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/1] aacraid: don't assign cpu_to_le32(int) to u8
Date: Wed, 7 Nov 2007 13:51:44 -0500
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01F95F54@otce2k301.adaptec.com>
In-Reply-To: <20071107173307.GB25560@infradead.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/1] aacraid: don't assign cpu_to_le32(int) to u8
Thread-Index: AcghZEdeLQ1O1P4NRgGI+ti40lAVigACjmLg
References: <jefxzqqeha.fsf@sykes.suse.de> <AE4F746F2AECFC4DA4AADD66A1DFEF01F95EF7@otce2k301.adaptec.com> <20071107173307.GB25560@infradead.org>
From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
To: "Christoph Hellwig" <hch@infradead.org>
Cc: "Andreas Schwab" <schwab@suse.de>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>, <linux-scsi@vger.kernel.org>,
       "LKML" <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig [mailto:hch@infradead.org] sez:
> Did anyone run the driver through sparse to see if we have 
> more issues like this?

There are some warnings from sparse, none like this one. I will deal
with the warnings ...

Sincerely -- Mark Salyzyn

