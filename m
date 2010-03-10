Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311Ab0CJNrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:47:17 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:56935 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216Ab0CJNrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:47:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=PYR1hgYQQW5qkcj3CiBN6Hcg3XRdIsKXk/l5Dyi8eXQH3PJRClM1c8QlReGBvh5b6y
         5LF5yQVTA3StiFm6idGedNpAqMBw79GllvIT0BkQ/+Ole7vcok2AXFh5k23rJpH4GEL5
         fa9k0RN1h0GYdWJID8u4LVMkUGFSw9orPuhfA=
Message-ID: <4B97A2DE.2030901@garzik.org>
Date: Wed, 10 Mar 2010 08:47:10 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>,
       James Bottomley <James.Bottomley@suse.de>, Tejun Heo <tj@kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Mark Lord <kernel@teksavvy.com>,
       tytso@mit.edu, "H. Peter Anvin" <hpa@zytor.com>,
       hirofumi@mail.parknet.co.jp, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       aschnell@suse.de, knikanth@suse.de, jdelvare@suse.de
Subject: Re: ATA 4 KiB sector issues.
References: <4B947393.2050002@kernel.org> <1268031640.4389.11.camel@mulgrave.site> <yq1vdd6bzgz.fsf@sermon.lab.mkp.net> <yq1mxyibz7o.fsf@sermon.lab.mkp.net> <yq1iq96bz22.fsf@sermon.lab.mkp.net> <20100310075334.GA26763@parisc-linux.org>
In-Reply-To: <20100310075334.GA26763@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2010 02:53 AM, Matthew Wilcox wrote:
> On Mon, Mar 08, 2010 at 10:41:57AM -0500, Martin K. Petersen wrote:
>> What I meant to say was that I know ATA supports 4 KB LBS and that
>> nobody appears to care about it.
>
> I sent patches to add support ... they were ignored.

Not true, read the rest of the thread.

	Jeff



