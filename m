Return-Path: <linux-kernel-owner+w=401wt.eu-S932094AbXHHGh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094AbXHHGh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 02:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754362AbXHHGhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 02:37:22 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:25020 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbXHHGhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 02:37:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Y98oJ07XcMUjqUb+N9QprriupVXnXjKPtS0OS9yBczU5T70N7H6b8iiC+iA07ByhwP/aqUPcCdk6yElvw61PGTmUF8gU9w7YWH8o0zGI9SxrDqfM6cVgYvve42EXasoI7xMf8SaVbOJM14hDiJ7rhRRrFZTXP0w5tyASqm+9R3I=
Date: Wed, 8 Aug 2007 15:37:14 +0900
From: Tejun Heo <htejun@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       satyam@infradead.org, cornelia.huck@de.ibm.com,
       stern@rowland.harvard.edu, Linux Containers <containers@lists.osdl.org>,
       gregkh@suse.de
Subject: Re: [PATCH 01/25] sysfs: Move all of inode initialization into sysfs_init_inode
Message-ID: <20070808063714.GU13674@htj.dyndns.org>
References: <11860582832964-git-send-email-htejun@gmail.com> <m1643rkqb6.fsf@ebiederm.dsl.xmission.com> <m11wefkq88.fsf_-_@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m11wefkq88.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2007 at 03:08:07PM -0600, Eric W. Biederman wrote:
> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

Acked-by: Tejun Heo <htejun@gmail.com>
