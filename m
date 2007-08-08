Return-Path: <linux-kernel-owner+w=401wt.eu-S1764399AbXHHJj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764399AbXHHJj2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 05:39:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754553AbXHHJjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 05:39:18 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:14215 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbXHHJjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 05:39:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=uo1b66NLxBEFQOkJTPj3FIJmsNyGj97T1dBxdQXa7KNNoXBeAWD9za+7pKCHOQr8l2lrTcf5Ys/4atpzUY8ezTNKajfoH9GG9GJxcKeZKPdcBb3Q5i3dOjUvbvJr6lJOS0l5eCrLDUJrSbpzMhDdX99m3NAkt+I57trmx2mobKQ=
Date: Wed, 8 Aug 2007 18:39:09 +0900
From: Tejun Heo <htejun@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       satyam@infradead.org, cornelia.huck@de.ibm.com,
       stern@rowland.harvard.edu, Linux Containers <containers@lists.osdl.org>,
       gregkh@suse.de
Subject: Re: [PATCH 22/25] sysfs: sysfs_uptdate_file handle multiple superblocks
Message-ID: <20070808093909.GN13674@htj.dyndns.org>
References: <m1lkcnhwfu.fsf_-_@ebiederm.dsl.xmission.com> <m1hcnbhwcy.fsf_-_@ebiederm.dsl.xmission.com> <m1d4xzhwb2.fsf_-_@ebiederm.dsl.xmission.com> <m18x8nhw8r.fsf_-_@ebiederm.dsl.xmission.com> <m14pjbhw6y.fsf_-_@ebiederm.dsl.xmission.com> <m1zm13ghlh.fsf_-_@ebiederm.dsl.xmission.com> <m1vebrghjg.fsf_-_@ebiederm.dsl.xmission.com> <m1r6mfghg9.fsf_-_@ebiederm.dsl.xmission.com> <m1myx3ghdt.fsf_-_@ebiederm.dsl.xmission.com> <m1ir7rghbg.fsf_-_@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ir7rghbg.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2007 at 03:34:11PM -0600, Eric W. Biederman wrote:
> 
> Teach sysfs_update_file how to handle multiple sysfs
> superblocks.  Again we are just iterating over the superblocks
> to so all of the filesystem modification notifications work
> as expected.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Same as the previous one.

-- 
tejun
