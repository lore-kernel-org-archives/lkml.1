Return-Path: <linux-kernel-owner+w=401wt.eu-S1756185AbZJ2Szt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbZJ2Szt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 14:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753620AbZJ2Szs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 14:55:48 -0400
Received: from brick.kernel.dk ([93.163.65.50]:34826 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755330AbZJ2Szs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 14:55:48 -0400
Date: Thu, 29 Oct 2009 19:55:51 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Alex Chiang <achiang@hp.com>
Cc: Mark Lord <lkml@rtr.ca>, Greg KH <greg@kroah.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org
Subject: Re: pci-express hotplug
Message-ID: <20091029185550.GV10727@kernel.dk>
References: <20091013172731.GB22797@ldl.fc.hp.com> <20091014081309.GM9228@kernel.dk> <20091020190707.GA25615@ldl.fc.hp.com> <20091026105419.GA10727@kernel.dk> <20091027024841.GA30509@ldl.fc.hp.com> <20091027082635.GS10727@kernel.dk> <20091027083419.GU10727@kernel.dk> <20091027151552.GB15737@ldl.fc.hp.com> <20091028091818.GZ10727@kernel.dk> <20091028195521.GA8749@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091028195521.GA8749@ldl.fc.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just a note for the archives - after chatting with Alex on irc about
this issue and trying other cards, the likely suspect seems to be the
specific card used and/or the firmware on that card. Hotplug works
otherwise, just not with that card at least.

-- 
Jens Axboe

