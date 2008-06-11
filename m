Return-Path: <linux-kernel-owner+w=401wt.eu-S1756685AbYFKW00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685AbYFKW00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 18:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753031AbYFKW0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 18:26:18 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:18909 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746AbYFKW0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 18:26:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=npa/g1g/CZzZuCQA0iYdPdwnPJ1eIMA7UqwvgpFCB1J/vFhwebW9o9APt+OZ1GjqD7
         qEYTcbPxu9235bRN+EsUF4QboRFx83Fz73W3Vv2hCsnkLQhlwuaqYaXLI0UhZr1vGV7M
         lbhsmxNJoo4WMpiGn1WPCQRjRCIhMRchgBA4I=
Message-ID: <57e2b00806111526t145b097dmc662bef379a1730f@mail.gmail.com>
Date: Wed, 11 Jun 2008 23:26:17 +0100
From: "Byron Bradley" <byron.bbradley@gmail.com>
To: "David Vrabel" <david.vrabel@csr.com>
Subject: Re: [patch] UWB: make UWB selectable on all archs with USB support
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, "Greg KH" <greg@kroah.com>
In-Reply-To: <484FB149.4080000@csr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080609053908.8021a635.akpm@linux-foundation.org>
	 <alpine.DEB.1.00.0806092250200.31236@gamma> <484FB149.4080000@csr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2008 at 12:04 PM, David Vrabel <david.vrabel@csr.com> wrote:
> Byron Bradley wrote:
>> I'm getting the error below when compiling for ARM (Marvell Orion 5x) but
>> having trouble working out exacty why. It looks like it isn't selecting
>> any of the CONFIG_UWB* options which USB_WHCI_HCD should select. Config is
>> attached.
>
> ARM (and some other architectures) don't use drivers/Kconfig.

Thanks David, I didn't realise that. No compilation problems now.

Cheers,

-- 
Byron Bradley
