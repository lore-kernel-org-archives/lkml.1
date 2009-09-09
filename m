Return-Path: <linux-kernel-owner+w=401wt.eu-S1754666AbZIIXyI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbZIIXyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 19:54:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754576AbZIIXyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 19:54:07 -0400
Received: from claw.goop.org ([74.207.240.146]:39972 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754556AbZIIXyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 19:54:06 -0400
Message-ID: <4AA84020.6040504@goop.org>
Date: Wed, 09 Sep 2009 16:54:08 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
       LKML <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       "Chetan.Loke@Emulex.Com" <Chetan.Loke@Emulex.Com>,
       James Bottomley <James.Bottomley@suse.de>, akataria@vmware.com,
       Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH] SCSI driver for VMware's virtual HBA - V4.
References: <1252458903.24914.73.camel@ank32.eng.vmware.com>	<4AA8177A.2020606@codemonkey.ws>	<1252533093.24633.40.camel@ank32.eng.vmware.com>	<4AA8284A.3010908@codemonkey.ws>	<20090909230854.GA4495@infradead.org> <4AA83B88.2020104@codemonkey.ws>
In-Reply-To: <4AA83B88.2020104@codemonkey.ws>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/09 16:34, Anthony Liguori wrote:
> We haven't even been successful in getting the Xen folks to present 
> their work on lkml before shipping it to their users.  Why would we 
> expect more from VMware if we're willing to merge the Xen stuff?
>   

The Xen code may be out of tree, but it has always been readily
available from a well-known place.  I don't think its comparable.

    J
