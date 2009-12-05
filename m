Return-Path: <linux-kernel-owner+w=401wt.eu-S1758049AbZLEUgC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049AbZLEUgC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 15:36:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758035AbZLEUf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 15:35:59 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:44954 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758030AbZLEUf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 15:35:59 -0500
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: miklos@szeredi.hu, luto@mit.edu, miklos@szeredi.hu,
       akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <20091205202838.3456b6fc@lxorguk.ukuu.org.uk> (message from Alan
	Cox on Sat, 5 Dec 2009 20:28:38 +0000)
Subject: Re: [PATCH v3] vfs: new O_NODE open flag
References: <E1NFrsv-0000mE-2L@pomaz-ex.szeredi.hu>
	<20091202191549.1dbffa2e@lxorguk.ukuu.org.uk>
	<E1NFva6-0001AI-0J@pomaz-ex.szeredi.hu>
	<20091202204828.4fa0c108@lxorguk.ukuu.org.uk>
	<E1NG4WJ-00026r-GE@pomaz-ex.szeredi.hu>
	<4B1A7159.3070101@mit.edu>
	<E1NH0Ub-0007oy-43@pomaz-ex.szeredi.hu> <20091205202838.3456b6fc@lxorguk.ukuu.org.uk>
Message-Id: <E1NH1MB-0007v8-Ps@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sat, 05 Dec 2009 21:35:55 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Dec 2009, Alan Cox wrote:
> I am concerned primarily about the lack of ability to get rid of such a
> handle in a controlled fashion. The udev/device unload case is simply one
> obvious way to exploit it.

I don't understand your concern.  Can you please ellaborate on the way
to exploit O_NODE?

Thanks,
Miklos
