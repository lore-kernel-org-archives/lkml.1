Return-Path: <linux-kernel-owner+w=401wt.eu-S1760033AbXKNLxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760033AbXKNLxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 06:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759192AbXKNLxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 06:53:00 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49961
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755082AbXKNLw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 06:52:59 -0500
Date: Wed, 14 Nov 2007 03:52:55 -0800 (PST)
Message-Id: <20071114.035255.91843147.davem@davemloft.net>
To: paulus@samba.org
Cc: hch@infradead.org, akpm@linux-foundation.org, gregkh@suse.de,
       mucci@cs.utk.edu, eranian@hpl.hp.com, wcohen@redhat.com,
       robert.richter@amd.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
From: David Miller <davem@davemloft.net>
In-Reply-To: <18234.56940.229831.735533@cargo.ozlabs.ibm.com>
References: <18234.53558.883970.87414@cargo.ozlabs.ibm.com>
	<20071114110009.GA17833@infradead.org>
	<18234.56940.229831.735533@cargo.ozlabs.ibm.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mackerras <paulus@samba.org>
Date: Wed, 14 Nov 2007 22:39:24 +1100

> No it's not basically a read().  It's more like a request/reply
> interface, which a read()/write() interface doesn't handle very well.

Yes it can, see my other reply.
