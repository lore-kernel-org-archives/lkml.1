Return-Path: <linux-kernel-owner+w=401wt.eu-S1754890AbYLJOlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbYLJOlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 09:41:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751697AbYLJOl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 09:41:28 -0500
Received: from mga03.intel.com ([143.182.124.21]:32439 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228AbYLJOl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 09:41:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,747,1220252400"; 
   d="scan'208";a="88621514"
Date: Wed, 10 Dec 2008 22:40:58 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jason Baron <jbaron@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] dynamic_printk: add line feed to printk
Message-ID: <20081210144058.GA11842@localhost>
References: <20081210073347.GA18737@localhost> <1228904326.19553.127.camel@violet.holtmann.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228904326.19553.127.camel@violet.holtmann.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 12:18:46PM +0200, Marcel Holtmann wrote:
> Hi,
> 
> > Append '\n' to two printk messages.
> 
> I already sent a patch for that and Greg picked it up.

No I didn't find it in the usb-2.6 tree:

git pull git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb-2.6.git
>From git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb-2.6
 * branch            HEAD       -> FETCH_HEAD
Already up-to-date.

> > Also cleanup the code to reduce one level of indentation.
> 
> Please re-base that one against Greg's latest tree that includes my
> patch.

Sorry, it's me :)

Thanks,
Fengguang

