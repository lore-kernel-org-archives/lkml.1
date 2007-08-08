Return-Path: <linux-kernel-owner+w=401wt.eu-S1758614AbXHHGiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614AbXHHGiD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 02:38:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755275AbXHHGhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 02:37:51 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:27796 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbXHHGht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 02:37:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=W0sK2E1UavJLTDMYrSjgKGQdh/Dpg1dCs+jM3dN3rnTXuaPpPGHulgidb7sx+Ieo5PsObvIMdNI83wtx5OVb/g/SvbfRNgSAEV0NSfHreRWK66kcAT9uJI2FIUQjK6npsDvZ2nTYPQc9Fu9XI5HZOo4Mz6VumF+wyVdKb7XPdNQ=
Date: Wed, 8 Aug 2007 15:37:42 +0900
From: Tejun Heo <htejun@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       satyam@infradead.org, cornelia.huck@de.ibm.com,
       stern@rowland.harvard.edu, Linux Containers <containers@lists.osdl.org>,
       gregkh@suse.de
Subject: Re: [PATCH 02/25] sysfs: Remove sysfs_instantiate
Message-ID: <20070808063742.GV13674@htj.dyndns.org>
References: <11860582832964-git-send-email-htejun@gmail.com> <m1643rkqb6.fsf@ebiederm.dsl.xmission.com> <m11wefkq88.fsf_-_@ebiederm.dsl.xmission.com> <m1wsw7jbml.fsf_-_@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1wsw7jbml.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2007 at 03:08:50PM -0600, Eric W. Biederman wrote:
> 
> Now that sysfs_get_inode is dropping the inode lock
> we no longer have a need from sysfs_instantiate.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Acked-by: Tejun Heo <htejun@gmail.com>
