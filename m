Return-Path: <linux-kernel-owner+w=401wt.eu-S1754493AbXLSI5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbXLSI5c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 03:57:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbXLSI5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 03:57:22 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:41520 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbXLSI5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 03:57:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=n/lAqUP/o/Ry2lvEWMZM7zGc2Vj7GemUQB0yI3kdezdQecus3z048LkeWEPn0p7B0lg1VD5YttcGxXB4l3F1gWKMd16LYeykGyPHx7phRZZDs32zBkYLSXnbDIgx3crMpVhBLAxAuEB4bMS0aqQp4Q4+jdTnoBEgyT+dgY2sqr8=
Message-ID: <4768DCEC.2090907@gmail.com>
Date: Wed, 19 Dec 2007 09:57:16 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Nico Schottelius <nico-kernel-20071219@schottelius.org>,
       Robert Hancock <hancockr@shaw.ca>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Out of memory and no killable processes: 2.6.22-2-686-bigmem
References: <fa.oSel00y9Hn5hvV3laxPiw9blEfU@ifi.uio.no> <4768692A.3030204@shaw.ca> <20071219055550.GE21042@denkbrett.schottelius.org>
In-Reply-To: <20071219055550.GE21042@denkbrett.schottelius.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2007 06:55 AM, Nico Schottelius wrote:
> And updating to 64 Bit kernel also implies changing the userland, so
> a reinstall would be necessary, wouldn't it?

No, if you enable ia32 support.
