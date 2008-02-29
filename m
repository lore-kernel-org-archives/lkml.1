Return-Path: <linux-kernel-owner+w=401wt.eu-S1756070AbYB2Bz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070AbYB2Bz7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 20:55:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbYB2Bzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 20:55:48 -0500
Received: from web36605.mail.mud.yahoo.com ([209.191.85.22]:38911 "HELO
	web36605.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750909AbYB2Bzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 20:55:47 -0500
X-YMail-OSG: k0c9tLcVM1lThq.P17PAQhyzTov_TgAOzL7zYYZEANKEfATx4PxGMn.bDURTRqgCNGeb8r70Yw--
X-RocketYMMF: rancidfat
Date: Thu, 28 Feb 2008 17:55:46 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 01/11] Security: Add hook to get full maclabel xattr name
To: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Christoph Hellwig <hch@infradead.org>
Cc: Dave Quigley <dpquigl@tycho.nsa.gov>, Stephen Smalley <sds@tycho.nsa.gov>,
       casey@schaufler-ca.com, viro@ftp.linux.org.uk, bfields@fieldses.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       LSM List <linux-security-module@vger.kernel.org>
In-Reply-To: <1204246805.7363.23.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <710000.44550.qm@web36605.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

> 
> On Thu, 2008-02-28 at 19:51 -0500, Christoph Hellwig wrote:
> > On Thu, Feb 28, 2008 at 04:50:06PM -0800, Trond Myklebust wrote:
> > > As I've told you several times before: we're _NOT_ putting private
> > > ioctl^Hxattrs onto the wire. If the protocol can't be described in an
> > > RFC, then it isn't going in no matter what expletive you choose to
> > > use...
> > 
> > It's as unstructured as the named attributes already in.  Or file data
> > for that matter.
> 
> Describing what is supposed to be a security mechanism in a structured
> fashion for use in a protocol should hardly be an impossible task (and
> AFAICS, Dave & co are making good progress in doing so). If it is, then
> that casts serious doubt on the validity of the security model...

Now this is were I always get confused. I sounds like you're
saying that a name/value pair is insufficiently structured for
use in a protocol specification.

> There should be no need for ioctls.

Sorry, but as far as I'm concerned you just threw a bunny under
the train for no apparent reason. What have ioctls got to do with
anything?


Casey Schaufler
casey@schaufler-ca.com
