Return-Path: <linux-kernel-owner+w=401wt.eu-S1756760AbZKDPZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760AbZKDPZl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 10:25:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756678AbZKDPZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 10:25:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42692 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756158AbZKDPZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 10:25:36 -0500
Date: Wed, 4 Nov 2009 07:23:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: johannes@sipsolutions.net, marcel@holtmann.org, dmitry.torokhov@gmail.com,
       torvalds@linux-foundation.org, linville@tuxdriver.com,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Please consider reverting
 7d930bc33653d5592dc386a76a38f39c2e962344
Message-Id: <20091104072315.18f56322.akpm@linux-foundation.org>
In-Reply-To: <20091104.004157.86565200.davem@davemloft.net>
References: <1257232587.3420.55.camel@localhost.localdomain>
	<1257234299.28469.25.camel@johannes.local>
	<20091103223433.23765578.akpm@linux-foundation.org>
	<20091104.004157.86565200.davem@davemloft.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Nov 2009 00:41:57 -0800 (PST) David Miller <davem@davemloft.net> wrote:

> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Tue, 3 Nov 2009 22:34:33 -0800
> 
> > Problem is, subsystem maintainers are very unreliable.
> 
> This is common, but not universal Andrew.

That's what I said too.

> Or, if it is, what patches from you have I been sitting on? :-)

zippo.  Although if you can help these:

isdn-hisax-fix-lock-imbalance.patch
hfc_usb-fix-read-buffer-overflow.patch
misdn-fix-reversed-if-in-st_own_ctrl.patch
isdn-eicon-use-offsetof.patch
isdn-eicon-return-on-error.patch
hisax-fix-test-in-waitforxfw.patch

move forward it'd be nice!
