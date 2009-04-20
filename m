Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbZDTKC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbZDTKC5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 06:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754653AbZDTKCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 06:02:45 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35808 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754621AbZDTKCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 06:02:44 -0400
Date: Mon, 20 Apr 2009 11:02:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Izik Eidus <ieidus@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, kvm@vger.kernel.org, avi@redhat.com,
       aarcange@redhat.com, chrisw@redhat.com, mtosatti@redhat.com,
       hugh@veritas.com, Izik Eidus <ieidus@redhat.com>
Subject: Re: [PATCH 5/5] add ksm kernel shared memory driver.
Message-ID: <20090420110223.76ba4593@lxorguk.ukuu.org.uk>
In-Reply-To: <1240191366-10029-6-git-send-email-ieidus@redhat.com>
References: <1240191366-10029-1-git-send-email-ieidus@redhat.com>
	<1240191366-10029-2-git-send-email-ieidus@redhat.com>
	<1240191366-10029-3-git-send-email-ieidus@redhat.com>
	<1240191366-10029-4-git-send-email-ieidus@redhat.com>
	<1240191366-10029-5-git-send-email-ieidus@redhat.com>
	<1240191366-10029-6-git-send-email-ieidus@redhat.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The minor number you are using already belongs to another project.

10,234 is free but it would be good to know what device naming is
proposed. I imagine other folks would like to know why you aren't using
sysfs or similar or extending /dev/kvm ?

Alan
