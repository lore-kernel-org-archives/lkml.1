Return-Path: <linux-kernel-owner+w=401wt.eu-S1759269AbZKYRhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759269AbZKYRhX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:37:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759056AbZKYRhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:37:22 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:45635 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758990AbZKYRhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:37:21 -0500
Message-ID: <4B0D6B4F.9030605@garzik.org>
Date: Wed, 25 Nov 2009 12:37:19 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/86] pata_cmd640: document known issues
References: <20091125170218.5446.13513.sendpatchset@localhost>	<20091125170436.5446.83994.sendpatchset@localhost> <20091125172633.7a15711b@lxorguk.ukuu.org.uk>
In-Reply-To: <20091125172633.7a15711b@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2009 12:26 PM, Alan Cox wrote:
> On Wed, 25 Nov 2009 18:04:36 +0100
> Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>  wrote:
>
>> From: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
>> Subject: [PATCH] pata_cmd640: document known issues
>>
>> Document known issues with the driver to aid distribution makers,
>> users and developers in making informed decisions instead of wasting
>> their time needlessly.
>
> Umm. its a) under CONFIG_PCI, and b) says CMD640 PCI IDE...

Agreed, that's a bit redundant.

Also, as I noted in another email, known issues should be listed in the 
driver source code at the top of the file, not in Kconfig.

That way the list of known issues actually follows the implementation, 
as the source code is copied around various kernel trees.

	Jeff




