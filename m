Return-Path: <linux-kernel-owner+w=401wt.eu-S1753181AbXKVSJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbXKVSJQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 13:09:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbXKVSJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 13:09:00 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:52765 "EHLO
	dorka.pomaz.szeredi.hu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752015AbXKVSJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 13:09:00 -0500
To: jdike@addtoit.com
CC: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-reply-to: <20071116170630.GA9299@c2.user-mode-linux.org> (message from Jeff
	Dike on Fri, 16 Nov 2007 12:06:30 -0500)
Subject: Re: uml doesn't work on 2.6.24-rc2
References: <E1Is5FL-00078H-00@dorka.pomaz.szeredi.hu> <20071114011002.GA11477@c2.user-mode-linux.org> <E1IsFbA-0007y2-00@dorka.pomaz.szeredi.hu> <20071114142247.GA5848@c2.user-mode-linux.org> <E1IsK83-0008CJ-00@dorka.pomaz.szeredi.hu> <20071114173639.GA7899@c2.user-mode-linux.org> <E1IsPo5-0008RU-00@dorka.pomaz.szeredi.hu> <20071116170630.GA9299@c2.user-mode-linux.org>
Message-Id: <E1IvGTn-0007cC-7q@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 22 Nov 2007 19:08:47 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Nov 14, 2007 at 10:29:57PM +0100, Miklos Szeredi wrote:
> > Config attached.
> 
> Thanks - this reproduces it for me.
> 
> BTW, you can work around this by enabling NO_HZ.

Thanks.  My other problem is (probably you are aware) that recent -mm
kernels don't compile for UML.

Miklos
