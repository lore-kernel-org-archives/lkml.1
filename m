Return-Path: <linux-kernel-owner+w=401wt.eu-S1762071AbZE0AD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762071AbZE0AD5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 20:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761871AbZE0ACi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 20:02:38 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:54261 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761873AbZE0ACg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 20:02:36 -0400
MIME-Version: 1.0
In-Reply-To: <1243381772.2815.96.camel@localhost.localdomain>
References: <ac3eb2510905261413r54e5bb18n7faf888aa55d8830@mail.gmail.com> 
	<Pine.LNX.4.44L0.0905261756390.11998-100000@iolanthe.rowland.org> 
	<ac3eb2510905261503k32db6197m84d1e78858e53da1@mail.gmail.com> 
	<1243381772.2815.96.camel@localhost.localdomain>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 27 May 2009 02:02:15 +0200
Message-ID: <ac3eb2510905261702n44c785a0hd0e59b5deb0fe903@mail.gmail.com>
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs 
	directories.
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       SCSI development list <linux-scsi@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 01:49, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:

> OK ... perhaps we have to wait a little harder: try this; it waits until
> all the targets have disappeared from visibility via an event.

That seems to work fine here.

Thanks,
Kay
