Return-Path: <linux-kernel-owner+w=401wt.eu-S1762106AbYJJS0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762106AbYJJS0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 14:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759217AbYJJS0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 14:26:32 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:43213 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758840AbYJJS0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 14:26:30 -0400
Date: Fri, 10 Oct 2008 13:26:25 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, casey@schaufler-ca.com,
       sds@tycho.nsa.gov, matthew.dodd@sparta.com, trond.myklebust@fys.uio.no,
       bfields@fieldses.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
       selinux@tycho.nsa.gov, labeled-nfs@linux-nfs.org
Subject: Re: [PATCH 03/14] Security: Add hook to calculate context based on
	a negative dentry.
Message-ID: <20081010182625.GA976@us.ibm.com>
References: <1222707986-26606-1-git-send-email-dpquigl@tycho.nsa.gov> <1222707986-26606-4-git-send-email-dpquigl@tycho.nsa.gov> <20080930201524.GC21039@us.ibm.com> <1223661253.3791.48.camel@moss-terrapins.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223661253.3791.48.camel@moss-terrapins.epoch.ncsc.mil>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David P. Quigley (dpquigl@tycho.nsa.gov):
> Should I implement this hook in the capabilities module as well?

Yup.

-serge
