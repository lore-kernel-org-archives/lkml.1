Return-Path: <linux-kernel-owner+w=401wt.eu-S1759378AbYFJUzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759378AbYFJUzf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 16:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758567AbYFJUyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 16:54:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758342AbYFJUyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 16:54:07 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0 of 7] Block/SCSI Data Integrity Support
References: <patchbomb.1212814533@sermon.lab.mkp.net>
	<x491w35bbdi.fsf@segfault.boston.devel.redhat.com>
	<yq1iqwhia2m.fsf@sermon.lab.mkp.net>
	<x49mylt9lbn.fsf@segfault.boston.devel.redhat.com>
	<yq1abhtnhjb.fsf@sermon.lab.mkp.net>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 10 Jun 2008 16:53:52 -0400
In-Reply-To: <yq1abhtnhjb.fsf@sermon.lab.mkp.net> (Martin K. Petersen's
	message of "Tue, 10 Jun 2008 16:47:52 -0400")
Message-ID: <x49wskx810f.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Martin K. Petersen" <martin.petersen@oracle.com> writes:

>>>>>> "Jeff" == Jeff Moyer <jmoyer@redhat.com> writes:
>
> Jeff> So, is it safe to say that the library routines for
> Jeff> integrity-aware file systems have not been tested at all?
> Jeff> Specifically, I'm talking about: bio_integrity_tag_size
> Jeff> bio_integrity_set_tag bio_integrity_get_tag
>
> I have not tried using them from within a filesystem, if that's what
> you mean.  But I have attached random strings to bios and read them
> back later.

I was checking to see if you had exercised the code at all, and you
have.  Great!

Cheers,

Jeff
