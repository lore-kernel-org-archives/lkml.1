Return-Path: <linux-kernel-owner+w=401wt.eu-S1754706AbZJFGuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbZJFGuI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 02:50:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754263AbZJFGuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 02:50:05 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:57238 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbZJFGuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 02:50:01 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
Organization: IBM
To: Amit Shah <amit.shah@redhat.com>
Subject: Re: [PATCH] virtio_console: Add support for multiple ports for generic guest and host communication
Date: Tue, 6 Oct 2009 08:49:22 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc2-prerelease; KDE/4.3.1; i686; ; )
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
References: <1252678386-17404-1-git-send-email-amit.shah@redhat.com> <200910011228.30563.borntraeger@de.ibm.com> <20091005140535.GA31333@amit-x200.redhat.com>
In-Reply-To: <20091005140535.GA31333@amit-x200.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910060849.22462.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 05 Oktober 2009 16:05:35 schrieb Amit Shah:
> On (Thu) Oct 01 2009 [12:28:30], Christian Borntraeger wrote:
> > With the latest git kernel + your patch I sometmes get a completely
> > frozen console. In the dump there is
> >
> >     <3>virtio_console virtio0: output:id 68 is not a head!
> >
> > Seems that I can reproduce it with large amounts of output (find / for
> > example) Without your patch everything is fine.
> 
> Hey Christian,
> 
> Can you try this patch?

This version seems to work on s390. Thanks

