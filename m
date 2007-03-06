Return-Path: <linux-kernel-owner+w=401wt.eu-S965749AbXCFCUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965749AbXCFCUm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 21:20:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965747AbXCFCUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 21:20:42 -0500
Received: from terminus.zytor.com ([192.83.249.54]:53982 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965741AbXCFCUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 21:20:41 -0500
Message-ID: <45ECCFF2.20103@zytor.com>
Date: Mon, 05 Mar 2007 18:20:34 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: klibc list <klibc@zytor.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: klibc integrated git tree updated to 2.6.21-rc2
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I realize I have been a bit MIA lately, but I'm going to try to make 
forward progress again on klibc.  I have pushed the current integrated 
tree up to 2.6.21-rc2; so far, no functional enhancements, but I'm 
looking at the following:

- Mount-by-label/mount-by-uuid.
- Ability to fall back on different roots.
- nfsroot on NFSv4.
- nfsroot over IPv6, as soon as the kernel supports NFS over IPv6.

As always, thoughts are appreciated.

	-hpa
