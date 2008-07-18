Return-Path: <linux-kernel-owner+w=401wt.eu-S1755601AbYGRK3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601AbYGRK3A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 06:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504AbYGRK2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 06:28:53 -0400
Received: from enyo.dsw2k3.info ([195.71.86.239]:41334 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567AbYGRK2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 06:28:52 -0400
Date: Fri, 18 Jul 2008 12:28:38 +0200
From: Matthias Schniedermeyer <ms@citd.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Fred ." <eldmannen@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Please add ZFS support (from GPL sources)
Message-ID: <20080718102838.GA13767@citd.de>
References: <f188924b0807171213q43f10b09j47b34674fc8aaa38@mail.gmail.com> <487F9D6D.7090808@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487F9D6D.7090808@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.07.2008 12:28, H. Peter Anvin wrote:
> Fred . wrote:
>> Previously we have not been able to have ZFS support due to it being
>> licensed under the CDDL and the kernel under the GPL.
>>
>> Sun have contributed ZFS support to GRUB under the GPL license. We
>> could now use that code to implement support for ZFS in the Linux
>> kernel.
>>
>> http://blogs.sun.com/darren/entry/zfs_under_gplv2_already_exists
>
> From what I can see, it is an absolutely-minimal readonly implementation.

Which wasn't problem for NTFS, which was RO for years.

RO is still better than nothing, you can copy files from an ZFS.



Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

