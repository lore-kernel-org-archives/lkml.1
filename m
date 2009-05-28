Return-Path: <linux-kernel-owner+w=401wt.eu-S1760557AbZE1ASR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760557AbZE1ASR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 20:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757895AbZE1AR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 20:17:59 -0400
Received: from kroah.org ([198.145.64.141]:53931 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754129AbZE1AR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 20:17:59 -0400
Date: Wed, 27 May 2009 17:14:18 -0700
From: Greg KH <greg@kroah.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Benjamin Thery <benjamin.thery@bull.net>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 01/20] sysfs: Implement sysfs_rename_link
Message-ID: <20090528001418.GA2499@kroah.com>
References: <m1bppofm9k.fsf@fess.ebiederm.org> <1242865694-2100-1-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242865694-2100-1-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So, there's been a lot of talk in this thread.

Eric, do you have an updated set of patches for me to try out?

Or are there still problems, like the "fry the ext3 boot partition" that
Kay found?

thanks,

greg k-h
