Return-Path: <linux-kernel-owner+w=401wt.eu-S1755197AbZJAI43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbZJAI43 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754454AbZJAI42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:56:28 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:52722 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbZJAI41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:56:27 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
Organization: IBM
To: Amit Shah <amit.shah@redhat.com>
Subject: Re: [PATCH] virtio_console: Add support for multiple ports for generic guest and host communication
Date: Thu, 1 Oct 2009 10:55:24 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc2-prerelease; KDE/4.3.1; i686; ; )
Cc: Rusty Russell <rusty@rustcorp.com.au>, Alan Cox <alan@linux.intel.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1252678386-17404-1-git-send-email-amit.shah@redhat.com> <200910011017.29502.borntraeger@de.ibm.com> <20091001084737.GA8385@amit-x200.redhat.com>
In-Reply-To: <20091001084737.GA8385@amit-x200.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910011055.24341.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 01 Oktober 2009 10:47:37 schrieb Amit Shah:
> > > It would be great if you could test this.
> >
> > The basic stuff seems to work, but when I did a console resize I get:
> 
> ...
> 
> > One of the config->get() related changes is probably wrong.
> 
> I see it. The following should fix it.

Yes, it does.
