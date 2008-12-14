Return-Path: <linux-kernel-owner+w=401wt.eu-S1754667AbYLNQxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbYLNQxV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 11:53:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753508AbYLNQxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 11:53:08 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:5834 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349AbYLNQxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 11:53:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=aAPYbGZqk5lENmqmCi+TVdABJJM895BVzLmnncYWx8ULtCRgAyR+gGfKR7Wnmsv1VB
         lyxVYuSZs6tT1iHBNSXVBcq5urj+aXW/N3g5jeJGKg4Db+9rMSH73ZhcXX1YdJg9UyVO
         PT/AI9fnaoxccMhlpVThKY5T8R6NO2poPuRko=
Message-ID: <e2e108260812140853l21be5a0cxe436bef8c47ccbba@mail.gmail.com>
Date: Sun, 14 Dec 2008 17:53:04 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: linux-iscsi-target-dev@googlegroups.com
Subject: Re: [Announce]: Target_Core_Mod/ConfigFS and LIO-Target v3.0 work
Cc: James.Bottomley@hansenpartnership.com, LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Christoph Hellwig" <hch@infradead.org>,
       "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>,
       "Mike Christie" <michaelc@cs.wisc.edu>,
       "Hannes Reinecke" <hare@suse.de>, "Jens Axboe" <jens.axboe@oracle.com>,
       "Vladislav Bolkhovitin" <vst@vlnb.net>
In-Reply-To: <1229208606.4153.1069.camel@haakon2.linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1228965271.4153.510.camel@haakon2.linux-iscsi.org>
	 <1229074809.4153.666.camel@haakon2.linux-iscsi.org>
	 <54939.1229149205@turing-police.cc.vt.edu>
	 <e2e108260812130141o3d21bbbdob9e7c9f95d309a74@mail.gmail.com>
	 <1229162907.4153.857.camel@haakon2.linux-iscsi.org>
	 <e2e108260812130223q13fd98d8gc1e55881a92b939@mail.gmail.com>
	 <1229167118.4153.930.camel@haakon2.linux-iscsi.org>
	 <e2e108260812130356y1fe60713xf844a35c775e161d@mail.gmail.com>
	 <1229181896.3258.27.camel@localhost.localdomain>
	 <1229208606.4153.1069.camel@haakon2.linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 13, 2008 at 11:50 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> On the other side however, the SCST guys are completely opposed to any
> usage of ConfigFS [ ... ]

It's sad to see that a few hours after James Bottomley asked to stop
fighting, that you are again spreading half truths about Vladislav and
myself. We are not opposed to any usage of configfs, but as Vladislav
carefully explained, we consider it unfortunate that the current
version of configfs doesn't suit SCST's needs.

Bart.
