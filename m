Return-Path: <linux-kernel-owner+w=401wt.eu-S1763671AbXHHHpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763671AbXHHHpm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 03:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755131AbXHHHpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 03:45:30 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:42519 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435AbXHHHp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 03:45:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Co/sCQNhtp2jJWVihAE4Maz0H686FSYjfNKHxFJtQkVSaOA1JJ00pT2eMUXPNGo8Z7dRqLc+JZK9LD4l4ea6GA9G/XtUscBz8Kru0dbmuSr6otsQaX+YlnB+gxoltOAJADHnt/1oELhwS9W9fNcIMRWhN8MvVy+sXttRrzTRKNo=
Date: Wed, 8 Aug 2007 16:45:20 +0900
From: Tejun Heo <htejun@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       satyam@infradead.org, cornelia.huck@de.ibm.com,
       stern@rowland.harvard.edu, Linux Containers <containers@lists.osdl.org>,
       gregkh@suse.de
Subject: Re: [PATCH 08/25] sysfs: Implement __sysfs_get_dentry
Message-ID: <20070808074520.GB13674@htj.dyndns.org>
References: <11860582832964-git-send-email-htejun@gmail.com> <m1643rkqb6.fsf@ebiederm.dsl.xmission.com> <m11wefkq88.fsf_-_@ebiederm.dsl.xmission.com> <m1wsw7jbml.fsf_-_@ebiederm.dsl.xmission.com> <m1sl6vjbjw.fsf_-_@ebiederm.dsl.xmission.com> <m1odhjjbij.fsf_-_@ebiederm.dsl.xmission.com> <m1k5s7jbh9.fsf_-_@ebiederm.dsl.xmission.com> <m1fy2vjbf9.fsf_-_@ebiederm.dsl.xmission.com> <m1bqdjjbcf.fsf_-_@ebiederm.dsl.xmission.com> <m17io7jba4.fsf_-_@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m17io7jba4.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2007 at 03:16:19PM -0600, Eric W. Biederman wrote:
> 
> This function is similar but much simpler to sysfs_get_dentry
> returns a sysfs dentry if one currently exists.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Acked-by: Tejun Heo <htejun@gmail.com>

-- 
tejun
