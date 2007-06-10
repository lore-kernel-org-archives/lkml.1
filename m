Return-Path: <linux-kernel-owner+w=401wt.eu-S1762266AbXFJHFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762266AbXFJHFU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 03:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760208AbXFJHFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 03:05:08 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:20901 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760198AbXFJHFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 03:05:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ogQD6NOGk+m3Gp1hcIR7u3pE82jf9LDfxfek2KD7EC372LDpHOvTdjYg+I2Kuu0Ye0u54b3FsCWOwKCQPfcp1xqNGNMV6PwMfE+L+CxRMy1Gz+iNgPAAFYGBJYArtP8Pq1tDLPC1eSK2fck6g4OjdyCoY4bz9MrHBi50WabFPRc=
Message-ID: <a781481a0706100005wf6b1e4ercfd94d9f4a80bbb@mail.gmail.com>
Date: Sun, 10 Jun 2007 12:35:05 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Marco Berizzi" <pupilla@hotmail.com>
Subject: Re: XFS internal error xfs_da_do_buf(2) at line 2087 of file fs/xfs/xfs_da_btree.c. Caller 0xc01b00bd
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <BAY103-DAV141D991980E54836534A00B2250@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <BAY103-DAV1066400DF0615AD677EA1B2730@phx.gbl>
	 <20070316012520.GN5743@melbourne.sgi.com>
	 <BAY103-DAV13EC09E9BCB3E8C9D5EEA2B2710@phx.gbl>
	 <20070316195951.GB5743@melbourne.sgi.com>
	 <BAY103-DAV1484A3797D5368C28969CBB2700@phx.gbl>
	 <BAY103-DAV9C465F21C87A900314523B2760@phx.gbl>
	 <20070320064632.GO32602149@melbourne.sgi.com>
	 <BAY103-DAV7076D9B4230E07680B724B2260@phx.gbl>
	 <20070607130505.GE85884050@sgi.com>
	 <BAY103-DAV141D991980E54836534A00B2250@phx.gbl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 6/8/07, Marco Berizzi <pupilla@hotmail.com> wrote:
> After few hours linux has crashed with this message:
> BUG: at arch/i386/kernel/smp.c:546 smp_call_function()

Which kernel (exactly) was this, and does this occur
reproducibly? Also, could you please send the dmesg,
stack trace, etc for when this happened?

Satyam
