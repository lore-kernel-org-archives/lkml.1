Return-Path: <linux-kernel-owner+w=401wt.eu-S1760090AbXGBOPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760090AbXGBOPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 10:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758168AbXGBOPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 10:15:45 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:12540 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759346AbXGBOPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 10:15:45 -0400
Message-ID: <468908A9.2010702@openvz.org>
Date: Mon, 02 Jul 2007 18:16:09 +0400
From: Kirill Korotaev <dev@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: en-us, en, ru
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: devel@openvz.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mark Fasheh <mark.fasheh@oracle.com>
Subject: jbd lost fix?
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan,

it looks like the following fix:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=43c3e6f5abdf6acac9b90c86bf03f995bf7d3d92

was lost after resurrecting of the spliced checkpointing list in this patch:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=78ce89c92bc6eaf5933b5664bff64253a7103bd7;hp=cdaad343b561cdeb38b0578bb038

Can you please confirm that?

Thanks,
Kirill

