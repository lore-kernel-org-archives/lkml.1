Return-Path: <linux-kernel-owner+w=401wt.eu-S1767449AbXDFAXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767449AbXDFAXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 20:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767451AbXDFAXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 20:23:42 -0400
Received: from terminus.zytor.com ([192.83.249.54]:36743 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767449AbXDFAXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 20:23:41 -0400
Message-ID: <461592FB.5060507@zytor.com>
Date: Thu, 05 Apr 2007 17:23:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: johnrobertbanks@fastmail.fm
CC: Ignatich <ignatich@gmail.com>, reiserfs-list@namesys.com,
       linux-kernel@vger.kernel.org
Subject: Re: Reiser4. BEST FILESYSTEM EVER? I need help.
References: <46157B5B.5000602@gmail.com> <1175817921.18400.1183285196@webmail.messagingengine.com>
In-Reply-To: <1175817921.18400.1183285196@webmail.messagingengine.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

johnrobertbanks@fastmail.fm wrote:
> 
> Anyway, I have patched the 2.6.20 kernel and have a partition formatted
> with Reiser4.
> 
> However, I am having trouble getting LILO or GRUB working (with
> Reiser4).
> 
> Could you guys who know all about this, help me, or point me to some
> help.
> 

Make your /boot a separate partition and format it as conservatively as 
possible (e.g. ext3, or even ext2.)

Problem solved.

	-hpa
