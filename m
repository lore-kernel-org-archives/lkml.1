Return-Path: <linux-kernel-owner+w=401wt.eu-S933011AbYGQTfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933011AbYGQTfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 15:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933089AbYGQT2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 15:28:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38069 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932783AbYGQT2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 15:28:50 -0400
Message-ID: <487F9D6D.7090808@zytor.com>
Date: Thu, 17 Jul 2008 12:28:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Fred ." <eldmannen@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Please add ZFS support (from GPL sources)
References: <f188924b0807171213q43f10b09j47b34674fc8aaa38@mail.gmail.com>
In-Reply-To: <f188924b0807171213q43f10b09j47b34674fc8aaa38@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fred . wrote:
> Previously we have not been able to have ZFS support due to it being
> licensed under the CDDL and the kernel under the GPL.
> 
> Sun have contributed ZFS support to GRUB under the GPL license. We
> could now use that code to implement support for ZFS in the Linux
> kernel.
> 
> http://blogs.sun.com/darren/entry/zfs_under_gplv2_already_exists

 From what I can see, it is an absolutely-minimal readonly implementation.

	-hpa
