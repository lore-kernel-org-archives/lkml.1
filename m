Return-Path: <linux-kernel-owner+w=401wt.eu-S1762192AbYFKPqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762192AbYFKPqv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 11:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762106AbYFKPqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 11:46:42 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:50044 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762085AbYFKPql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 11:46:41 -0400
Date: Wed, 11 Jun 2008 10:46:37 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Dan Smith <danms@us.ibm.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Paul Menage <menage@google.com>,
       Linux Containers <containers@lists.osdl.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] cgroup_clone: use pid of newly created task for
	new cgroup
Message-ID: <20080611154637.GB23134@us.ibm.com>
References: <20080610212302.GA1946@us.ibm.com> <87ve0ggi2k.fsf@caffeine.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ve0ggi2k.fsf@caffeine.beaverton.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Dan Smith (danms@us.ibm.com):
> SH> As a result, the new cgroup was created with current's pid.
> 
> This works for me and results in the creation of a cgroup named after
> the new task's pid instead of the parent's pid.
> 
> Thanks!

Cool, thanks Dan, I'll add a Tested-by: from you if you don't mind?

thanks,
-serge
