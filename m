Return-Path: <linux-kernel-owner+w=401wt.eu-S1753736AbZDUAjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736AbZDUAjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 20:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbZDUAjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 20:39:06 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:33112 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbZDUAjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 20:39:04 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; charset=us-ascii
Date: Mon, 20 Apr 2009 18:38:47 -0600
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [LTP] statvfs -> f_bavail
In-reply-to: <20090421002503.GA8633@ZenIV.linux.org.uk>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Michal Simek <michal.simek@petalogix.com>,
       Nate Straz <nate-ltp@refried.org>, subrata@linux.vnet.ibm.com,
       ltp-list@lists.sourceforge.net,
       John Williams <john.williams@petalogix.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Message-id: <20090421003847.GO3209@webber.adilger.int>
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <49E759FB.70103@petalogix.com> <49E847FB.1030801@petalogix.com>
 <20090417173107.GA3590@refried.org> <49EC1352.6010900@petalogix.com>
 <20090420062642.GY26366@ZenIV.linux.org.uk> <49EC1945.1000805@petalogix.com>
 <20090421002503.GA8633@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 21, 2009  01:25 +0100, Al Viro wrote:
> 	a) ramfs has no such thing as "amount of available space", simply
> because it has no limit on total size occupied.

Well, except the amount of RAM in the system, which would be a reasonable
value to use.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

