Return-Path: <linux-kernel-owner+w=401wt.eu-S1754909AbYB2BGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbYB2BGX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 20:06:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932838AbYB2Av1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 19:51:27 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40662 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932816AbYB2Av0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 19:51:26 -0500
Date: Thu, 28 Feb 2008 19:51:13 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Christoph Hellwig <hch@infradead.org>,
       Dave Quigley <dpquigl@tycho.nsa.gov>,
       Stephen Smalley <sds@tycho.nsa.gov>, casey@schaufler-ca.com,
       viro@ftp.linux.org.uk, bfields@fieldses.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       LSM List <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 01/11] Security: Add hook to get full maclabel xattr
	name
Message-ID: <20080229005113.GA24087@infradead.org>
References: <746385.69480.qm@web36611.mail.mud.yahoo.com> <1204227035.31790.207.camel@moss-spartans.epoch.ncsc.mil> <20080228234850.GA25829@infradead.org> <1204243497.2715.24.camel@moss-terrapins.epoch.ncsc.mil> <20080229003937.GA16343@infradead.org> <1204246206.7363.13.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204246206.7363.13.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 04:50:06PM -0800, Trond Myklebust wrote:
> As I've told you several times before: we're _NOT_ putting private
> ioctl^Hxattrs onto the wire. If the protocol can't be described in an
> RFC, then it isn't going in no matter what expletive you choose to
> use...

It's as unstructured as the named attributes already in.  Or file data
for that matter.

