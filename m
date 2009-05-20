Return-Path: <linux-kernel-owner+w=401wt.eu-S1756767AbZETXFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767AbZETXFI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 19:05:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754609AbZETXE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 19:04:57 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:36241 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548AbZETXE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 19:04:56 -0400
To: Greg KH <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/20] Sysfs cleanups
References: <m1bppofm9k.fsf@fess.ebiederm.org>
	<20090520153718.GB26111@suse.de>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 20 May 2009 16:04:48 -0700
In-Reply-To: <20090520153718.GB26111@suse.de> (Greg KH's message of "Wed\, 20 May 2009 08\:37\:18 -0700")
Message-ID: <m1skizgyun.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: gregkh@suse.de, linux-fsdevel@vger.kernel.org, cornelia.huck@de.ibm.com, tj@kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Exit with error (see exim mainlog)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:

> On Tue, May 19, 2009 at 09:09:43PM -0700, Eric W. Biederman wrote:
>> 
>> The following patch series cleans up sysfs to the point where itq is
>> generally a good citizen of the vfs layer.  The big theme is lazy
>> synchronization from the sysfs data structures to the vfs data
>> structures using the same techniques as most other distributed
>> filesystems.
>
> Hm, I only seem to have gotten patch 0/20, none of the actual patches.
> Did I somehow miss them?
>
> confused,

Me too.

git-send-email ran.  I got copies of the mail sent.  But fsdevel
and linux-kernel appears not to have received them.  Hopefully I can figure
out what went wrong shortly.  My apologies if anyone receives several copies.

Eric
