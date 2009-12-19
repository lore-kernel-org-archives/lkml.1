Return-Path: <linux-kernel-owner+w=401wt.eu-S1754289AbZLSWeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289AbZLSWeS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 17:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088AbZLSWeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 17:34:18 -0500
Received: from mail-gx0-f211.google.com ([209.85.217.211]:34187 "EHLO
	mail-gx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944AbZLSWeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 17:34:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Nf8ZiK/mJ+WHj+JY5S3PhEKVmIA17rFbxX6xePxkQTeZezoz0wT1kb9O4cR0gy7evA
         IBpCAPDCVlO3hCUqDjZm5swoVK4aNyKCTE7r3DC2I5h5HpI5YDGoY+zdZbBwH3ILj+LK
         RNAklfgnEEsSptiUgoIuie+tcTKar08b0T45M=
Message-ID: <4B2D54E7.9060508@garzik.org>
Date: Sat, 19 Dec 2009 17:34:15 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.33-rc0 regression: 256MB CF card no longer recognized in
 PCMCIA slot
References: <20091219215459.GB9011@elf.ucw.cz>
In-Reply-To: <20091219215459.GB9011@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2009 04:55 PM, Pavel Machek wrote:
> Hi!
>
> Subject pretty much says it all... I do get some messages on the
> console, I'll try to gather them.

Which driver(s) no longer see it?  Do you think it's the PCMCIA 
subsystem, IDE, libata or other?

	Jeff




