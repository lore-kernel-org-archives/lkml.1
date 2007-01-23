Return-Path: <linux-kernel-owner+w=401wt.eu-S932164AbXAWBfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164AbXAWBfF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 20:35:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932433AbXAWBfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 20:35:05 -0500
Received: from smtp.bulldogdsl.com ([212.158.248.7]:4490 "EHLO
	mcr-smtp-001.bulldogdsl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932164AbXAWBfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 20:35:03 -0500
X-Spam-Abuse: Please report all spam/abuse matters to abuse@bulldogdsl.com
From: Alistair John Strachan <s0348365@sms.ed.ac.uk>
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: SATA exceptions with 2.6.20-rc5
Date: Tue, 23 Jan 2007 01:34:57 +0000
User-Agent: KMail/1.9.5
Cc: =?utf-8?q?Bj=C3=B6rn_Steinbrink?= <B.Steinbrink@gmx.de>,
       Jeff Garzik <jeff@garzik.org>, Chr <chunkeey@web.de>,
       linux-kernel@vger.kernel.org, htejun@gmail.com, jens.axboe@oracle.com,
       lwalton@real.com, pomac@vapor.com
References: <fa.ow4pXUncgdZmfLf3oyfrn1W+Bk0@ifi.uio.no> <fa.4QxeKMcmkoyhlL26AivZV6BFQJQ@ifi.uio.no> <45B563C6.5070505@shaw.ca>
In-Reply-To: <45B563C6.5070505@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701230134.57775.s0348365@sms.ed.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 January 2007 01:24, Robert Hancock wrote:
> As a final aside, this is another case where the hardware docs for this
> controller would really be useful, in order to know whether we are
> actually supposed to be reading that register in ADMA mode or not. I
> sent a query to Allen Martin at NVIDIA asking if there's a way I could
> get access to the documents, but I haven't heard anything yet.

Obviously, NVIDIA's response is disappointing, but thank you for putting the 
time in to debug this problem. Definitely sounds like a hardware defect, I'm 
just glad there's a workaround.

Will we see this fix in 2.6.20?

-- 
Cheers,
Alistair.

Final year Computer Science undergraduate.
1F2 55 South Clerk Street, Edinburgh, UK.
