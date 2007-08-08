Return-Path: <linux-kernel-owner+w=401wt.eu-S934722AbXHHGvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934722AbXHHGvq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 02:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755911AbXHHGvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 02:51:33 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:39477 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758928AbXHHGvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 02:51:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=FIL61xWJDB78eTLe8eI/RmYHhCC/XdN4PEAK1WHt/y9ulnUyOd6cx7pxLv6x2FQzzCPdYMcPXA09TXpHOVuG5yreSmet7Y7mXxxLgxftYXn8Sso2/cStAoeDCNz3lXRp0LyxJ7f97YWu4QnBFO0irCvJLQhxFgHZfBvGUFX87b8=
Date: Wed, 8 Aug 2007 15:51:23 +0900
From: Tejun Heo <htejun@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       satyam@infradead.org, cornelia.huck@de.ibm.com,
       stern@rowland.harvard.edu, Linux Containers <containers@lists.osdl.org>,
       gregkh@suse.de
Subject: Re: [PATCH 05/25] sysfs: In sysfs_lookup don't open code sysfs_find_dirent
Message-ID: <20070808065123.GY13674@htj.dyndns.org>
References: <11860582832964-git-send-email-htejun@gmail.com> <m1643rkqb6.fsf@ebiederm.dsl.xmission.com> <m11wefkq88.fsf_-_@ebiederm.dsl.xmission.com> <m1wsw7jbml.fsf_-_@ebiederm.dsl.xmission.com> <m1sl6vjbjw.fsf_-_@ebiederm.dsl.xmission.com> <m1odhjjbij.fsf_-_@ebiederm.dsl.xmission.com> <m1k5s7jbh9.fsf_-_@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1k5s7jbh9.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2007 at 03:12:02PM -0600, Eric W. Biederman wrote:
> 
> This is a small cleanup patch that makes the code just
> a little bit cleaner.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Acked-by: Tejun Heo <htejun@gmail.com>

-- 
tejun
