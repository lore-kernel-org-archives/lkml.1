Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132Ab0CICmt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 21:42:49 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:52458 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098Ab0CICmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 21:42:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Q49HBsXq7/0e1cifoaqyZJvlTX5BEqsTrKvtZOfwpOARsn6FP7dEHDPIr3WDmT5cQP
         Rwkscv4TsCv3PNsvkuY7azIRbpTTfm6mCCqtskGEzC2mJI6Mii23I4gyU+Ohoq9qd8eU
         SxKFIFmUhw0MQKM4EcOYocHiqwFWjX11G2N8A=
Message-ID: <4B95B5A2.2090902@garzik.org>
Date: Mon, 08 Mar 2010 21:42:42 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Karel Zak <kzak@redhat.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Mark Lord <kernel@teksavvy.com>,
       tytso@mit.edu, "H. Peter Anvin" <hpa@zytor.com>,
       hirofumi@mail.parknet.co.jp, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de, Jim Meyering <jim@meyering.net>
Subject: Re: ATA 4 KiB sector issues.
References: <4B947393.2050002@kernel.org> <yq1zl2ic058.fsf@sermon.lab.mkp.net> <20100308195847.GC18077@nb.net.home> <4B95B39C.70402@kernel.org>
In-Reply-To: <4B95B39C.70402@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2010 09:34 PM, Tejun Heo wrote:
> libata is broken for logical 4KiB ATA devices tho.  I'll fix it up.

Does libata-dev.git#sectsize miss any details?

	Jeff



