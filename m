Return-Path: <linux-kernel-owner+w=401wt.eu-S1756606AbYLKPYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606AbYLKPYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 10:24:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755648AbYLKPYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 10:24:15 -0500
Received: from Mycroft.westnet.com ([216.187.52.7]:62471 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212AbYLKPYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 10:24:14 -0500
X-Greylist: delayed 1550 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Dec 2008 10:24:13 EST
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18753.10882.836216.883757@stoffel.org>
Date: Thu, 11 Dec 2008 09:58:10 -0500
From: "John Stoffel" <john@stoffel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Phillips <phillips@phunq.net>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, tux3@tux3.org
Subject: Re: Tux3 report: Tux3 by Christmas?
In-Reply-To: <20081210233617.ddb3fa30.akpm@linux-foundation.org>
References: <200812101435.40393.phillips@phunq.net>
	<20081210233617.ddb3fa30.akpm@linux-foundation.org>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Andrew" == Andrew Morton <akpm@linux-foundation.org> writes:

Andrew> On Wed, 10 Dec 2008 14:35:39 -0800 Daniel Phillips <phillips@phunq.net> wrote:
>> The big goals for Christmas (this Christmas!) are:

Andrew> Also, don't feel that a merge would lock you into the current
Andrew> on-disk layout.  I think it would be acceptable to emit a big
Andrew> printk("the format of this fs will change without notice.  Do
Andrew> not yet store any data on a tux3 fs") during mount().  For a
Andrew> while.

Hear hear!  I keep wanting to play with ext4,btrfs and tux3, but I
don't have the time to grab and play mix and match with git right
now.  

Daniel, please start the push to merge!  

John
