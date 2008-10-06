Return-Path: <linux-kernel-owner+w=401wt.eu-S1754026AbYJFRfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbYJFRfY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 13:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125AbYJFRfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 13:35:10 -0400
Received: from gv-out-0910.google.com ([216.239.58.189]:5993 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbYJFRfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 13:35:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=p8Ww6WrEJXOq2+DpUAPAXLVaBnkl6rHRYFpLoNsuHBUlxoziqhLbL7NxVX6RnDWPar
         pqZby6ZEniTY7kiGSfTUx9kFG27gG4UFuo2D9/HKJJOj3H8GvTKd++vmBEqOti4Ojr/e
         JYnTNqRFJl/EuQ8Wf2SHxKsbmNa6Gx16aZ2aw=
From: Andrey Batyiev <batyiev@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: APIC misconfiguration
Date: Mon, 6 Oct 2008 20:30:42 +0300
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200810061923.09076.batyiev@gmail.com> <200810061955.28915.batyiev@gmail.com> <20081006171742.GB7317@localhost>
In-Reply-To: <20081006171742.GB7317@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810062030.42952.batyiev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> hmm... don't we have any ISA quirks already? If this device support
> PnP there should be descriptor for irq line where you could change it
> since I don't believe it would be a first device in kernel which behave
> not as supposed and developers has to override some configs bits.
> Hope it help (i didn't check ISA code though -- too busy now).

Well, it seems device haven't either PnP or isapnp doesn't detect it.

Thanks,
   Andrey
