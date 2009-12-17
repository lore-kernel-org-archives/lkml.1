Return-Path: <linux-kernel-owner+w=401wt.eu-S1752990AbZLQMFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990AbZLQMFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 07:05:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756041AbZLQMFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 07:05:53 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:46521 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbZLQMFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 07:05:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=hxT6HJK/vdqi2aGAvtT2gpEg+2ohXrN1a7XdVWJdesX3TeIxl2kgUmi/UqqIFlU+Gs
         VbHSgjaL0+YiBJ2lTXhjMeTvyyfB1eqXNESXUe+mX/UfzTp+ha3dGI30w0ODJ+IC7OWR
         zVXbGCtlmX065b2Prt0mu7ZAS8ySnepTBj96c=
Message-ID: <4B2A1E9E.30009@garzik.org>
Date: Thu, 17 Dec 2009 07:05:50 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Romain Kubany <rkubany@ikoula.com>
CC: Mikael Pettersson <mikpe@it.uu.se>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: Possible regression of LBA48 support for piix
References: <A9C151C7BD19EC47976D4AA14CF277A8BC64DFB2AF@HMCEXMBX01CLUS.hmcikoula.com> <19241.63911.160765.909812@pilspetsen.it.uu.se> <A9C151C7BD19EC47976D4AA14CF277A8BC64DFB2C1@HMCEXMBX01CLUS.hmcikoula.com> <4B2A1008.9070202@garzik.org>
In-Reply-To: <4B2A1008.9070202@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2009 06:03 AM, Jeff Garzik wrote:
> On 12/17/2009 05:04 AM, Romain Kubany wrote:
>> Here is the new kernel config file : http://pastebin.com/f65fd472b
>
> I would definitely be interested in seeing the 'dmesg' output for
> libata, and results from a more recent kernel.

Also, what does 'hdparm -I /dev/XXXX' output look like?

	Jeff



