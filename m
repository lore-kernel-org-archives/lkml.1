Return-Path: <linux-kernel-owner+w=401wt.eu-S1756612AbZEZV5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612AbZEZV5O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 17:57:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757266AbZEZV46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 17:56:58 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40058 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754685AbZEZV45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 17:56:57 -0400
Date: Tue, 26 May 2009 17:56:58 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Kay Sievers <kay.sievers@vrfy.org>
cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       SCSI development list <linux-scsi@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       <linux-fsdevel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs  directories.
In-Reply-To: <ac3eb2510905261413r54e5bb18n7faf888aa55d8830@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0905261756390.11998-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 May 2009, Kay Sievers wrote:

> Ok, I copied my newly installed system to another disks, to have a
> root filesytem to trash again by this bug. :)
> 
> Which of your patches should I try?

James's patch, not mine.

Alan Stern

