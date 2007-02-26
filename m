Return-Path: <linux-kernel-owner+w=401wt.eu-S964932AbXBZKEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964932AbXBZKEg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 05:04:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964988AbXBZKEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 05:04:36 -0500
Received: from il.qumranet.com ([82.166.9.18]:39363 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964932AbXBZKEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 05:04:36 -0500
Message-ID: <45E2B0AC.1090009@qumranet.com>
Date: Mon, 26 Feb 2007 12:04:28 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Gerd Hoffmann <kraxel@suse.de>
CC: kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [kvm-devel] [ANNOUNCE] kvm-15 release
References: <45E16E54.60503@qumranet.com> <45E2AD54.7020709@suse.de>
In-Reply-To: <45E2AD54.7020709@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gerd Hoffmann wrote:
> Avi Kivity wrote:
>   
>> - new userspace interface (work in progress)
>>     
>
> kvmfs in kvm-15 kernel code does not to build with older kernels (2.6.16
> fails, 2.6.18 works ok), looks like the reason are some changes in
> superblock handling.
>
> Do you intend to fix that?
>   

Yes, though it's rather low priority right now.  Patches will be applied.

-- 
error compiling committee.c: too many arguments to function

