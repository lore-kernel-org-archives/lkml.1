Return-Path: <linux-kernel-owner+w=401wt.eu-S1752883AbYHSOqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbYHSOqu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 10:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbYHSOqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 10:46:42 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:56066 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbYHSOqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 10:46:42 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Aug 2008 10:46:41 EDT
Message-ID: <48AADB39.5060201@davidnewall.com>
Date: Wed, 20 Aug 2008 00:09:53 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Chen Pei Chao <jackie73@ms2.hinet.net>
CC: linux-kernel@vger.kernel.org, jackie.chen@foxconn.com
Subject: =?windows-1255?Q?Re=3A_Is_there_linux_RAM_filesystem_?=
 =?windows-1255?Q?with_a_fixed_amount_of_memory=3F=FE?=
References: <016201c90203$b12fff40$110afea9@acer44836bb3d7>
In-Reply-To: <016201c90203$b12fff40$110afea9@acer44836bb3d7>
Content-Type: text/plain; charset=windows-1255
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Is there any RAM file system that use a fixed amount of memory at all times
> and will not grow and shrink dynamically like tmpfs?

ramfs
