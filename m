Return-Path: <linux-kernel-owner+w=401wt.eu-S1759177AbZCaBmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759177AbZCaBmm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 21:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754565AbZCaBma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 21:42:30 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:32802 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716AbZCaBm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 21:42:29 -0400
Message-ID: <49D174FC.80900@codemonkey.ws>
Date: Mon, 30 Mar 2009 20:42:20 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Izik Eidus <ieidus@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
       avi@redhat.com, aarcange@redhat.com, chrisw@redhat.com, riel@redhat.com,
       jeremy@goop.org, mtosatti@redhat.com, hugh@veritas.com, corbet@lwn.net,
       yaniv@redhat.com, dmonakhov@openvz.org
Subject: Re: [PATCH 0/4] ksm - dynamic page sharing driver for linux
References: <1238457560-7613-1-git-send-email-ieidus@redhat.com>
In-Reply-To: <1238457560-7613-1-git-send-email-ieidus@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Izik Eidus wrote:
> I am sending another seires of patchs for kvm kernel and kvm-userspace
> that would allow users of kvm to test ksm with it.
> The kvm patchs would apply to Avi git tree.
>   
Any reason to not take these through upstream QEMU instead of 
kvm-userspace?  In principle, I don't see anything that would prevent 
normal QEMU from almost making use of this functionality.  That would 
make it one less thing to eventually have to merge...

Regards,

Anthony Liguori
