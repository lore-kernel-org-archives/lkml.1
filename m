Return-Path: <linux-kernel-owner+w=401wt.eu-S1760159AbXKHGtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760159AbXKHGtR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 01:49:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751419AbXKHGtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 01:49:06 -0500
Received: from il.qumranet.com ([82.166.9.18]:38657 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833AbXKHGtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 01:49:05 -0500
Message-ID: <4732B15C.8040304@qumranet.com>
Date: Thu, 08 Nov 2007 08:49:00 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Anthony Liguori <aliguori@us.ibm.com>
CC: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rusycorp.com.au>,
       virtualization@lists.osdl.org, kvm-devel@lists.sourceforge.net
Subject: Re: [kvm-devel] [PATCH 2/3] Put the virtio under the virtualization
 menu
References: <11944899922822-git-send-email-aliguori@us.ibm.com>	<11944900141678-git-send-email-aliguori@us.ibm.com> <11944900152750-git-send-email-aliguori@us.ibm.com>
In-Reply-To: <11944900152750-git-send-email-aliguori@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Thu, 08 Nov 2007 08:49:00 +0200 (IST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
> This patch moves virtio under the virtualization menu and changes virtio
> devices to not claim to only be for lguest.
>   

Perhaps the virt menu needs to be split into a host-side support menu
and guest-side support menu.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

