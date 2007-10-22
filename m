Return-Path: <linux-kernel-owner+w=401wt.eu-S1752573AbXJVWbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbXJVWbN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 18:31:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750971AbXJVWa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 18:30:59 -0400
Received: from hu-out-0506.google.com ([72.14.214.239]:57979 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbXJVWa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 18:30:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=EbeYNCwOlTzBSwN537dvN1xnA+vvtTMOIsmSPBCPbYl9axbB8aqMbey16ILfEdYiHApdCUxTanj5obw/8zyjWd5QIOQNNS1qVcOTBJl26d+M4A5mVebWVmXPSEtBQ/9Wg3pexk5E9DDJ8GZuT7+/tQna+o/S9gghD4JkTfPS+ic=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Anas Nashif <nashif@linux.intel.com>
Subject: Re: [PATCH] Intel Manageability Engine Interface driver
Date: Tue, 23 Oct 2007 00:30:03 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, Marek Dabek <marek.dabek@intel.com>,
       Andrew Morton <akpm@osdl.org>
References: <471CDC5E.4010300@linux.intel.com>
In-Reply-To: <471CDC5E.4010300@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710230030.03705.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 October 2007 19:22:38 Anas Nashif wrote:
> The Manageability Engine Interface (aka HECI) allows applications to 
> communicate with the Intel(R) Manageability Engine (ME) firmware.
> 
> It is meant to be used by user-space manageability applications to
> access ME features such as Intel(R) Active Management Technology,
> Intel(R) Quiet System Technology and ASF.
> 
> The patch is large so I'm placing the diff on the web for download
> rather than attaching it here.  Download:
> 
> http://download.openamt.org/intel-MEI.diff
> 
> 
> Anas
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


Will integrated sensors on DG965 motherboard be supported?
They can be accessed only through the
HECI interface, but the board has no AMT, and even if it had one, I don't 
think AMT includes HW sensors.

Will it be supported?
I really need it (I have to reboot to bios each time to see the sensors, which is
both inaccurate, and annoying)


Best regards,
	Maxim Levitsky
