Return-Path: <linux-kernel-owner+w=401wt.eu-S1761609AbYB1BWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761609AbYB1BWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 20:22:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbYB1BWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 20:22:41 -0500
Received: from namei.org ([69.55.235.186]:48265 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751174AbYB1BWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 20:22:40 -0500
Date: Thu, 28 Feb 2008 12:22:05 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Dave Quigley <dpquigl@tycho.nsa.gov>
cc: hch@infradead.org, viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no,
       bfields@fieldses.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 08/11] NFS: Introduce lifecycle management for label
 attribute.
In-Reply-To: <1204159673.24345.15.camel@moss-terrapins.epoch.ncsc.mil>
Message-ID: <Xine.LNX.4.64.0802281220440.27221@us.intercode.com.au>
References: <1204144786-3502-1-git-send-email-dpquigl@tycho.nsa.gov> 
 <1204144786-3502-9-git-send-email-dpquigl@tycho.nsa.gov> 
 <Xine.LNX.4.64.0802281157170.27221@us.intercode.com.au>
 <1204159673.24345.15.camel@moss-terrapins.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008, Dave Quigley wrote:

> > Perhaps introduce a debug configuration option for this code.
> 
> In what way? We can change them to respond to the NFS/NFSD debug
> variables that are set through proc, or did you have something else in
> mind?

I was thinking something along the lines of CONFIG_NETFILTER_DEBUG, but I 
guess you can also use the NFS debug facilities.


-- 
James Morris
<jmorris@namei.org>
