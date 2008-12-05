Return-Path: <linux-kernel-owner+w=401wt.eu-S1756230AbYLEEsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbYLEEsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 23:48:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbYLEEsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 23:48:11 -0500
Received: from tundra.namei.org ([65.99.196.166]:59401 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073AbYLEEsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 23:48:09 -0500
Date: Fri, 5 Dec 2008 15:47:27 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
cc: hch@infradead.org, viro@zeniv.linux.org.uk, casey@schaufler-ca.com,
       sds@tycho.nsa.gov, "Matthew N. Dodd" <matthew.dodd@sparta.com>,
       trond.myklebust@fys.uio.no, bfields@fieldses.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov,
       labeled-nfs@linux-nfs.org
Subject: Re: [PATCH 09/14] NFS: Add security_label text mount option and
 handling code to NFS
In-Reply-To: <1227733394-1114-10-git-send-email-dpquigl@tycho.nsa.gov>
Message-ID: <alpine.LRH.1.10.0812051546560.12208@tundra.namei.org>
References: <1227733394-1114-1-git-send-email-dpquigl@tycho.nsa.gov> <1227733394-1114-10-git-send-email-dpquigl@tycho.nsa.gov>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2008, David P. Quigley wrote:

> +	{ Opt_security_label, "security_label" },
> +	{ Opt_nosecurity_label, "nosecurity_label" },

"seclabel" might be easier for admins to type.


-- 
James Morris
<jmorris@namei.org>
