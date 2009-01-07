Return-Path: <linux-kernel-owner+w=401wt.eu-S1758081AbZAGAqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758081AbZAGAqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 19:46:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754296AbZAGAqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 19:46:37 -0500
Received: from mail-out1.uio.no ([129.240.10.57]:53787 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386AbZAGAqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 19:46:36 -0500
Message-ID: <ae2fa56f38f87da3a90ab6fe39954b2b.squirrel@webmail.uio.no>
Date: Tue, 6 Jan 2009 19:39:39 -0500 (EST)
Subject: Re: [RFC][PATCH 2/4] sunrpc: Use utsnamespaces
From: trond.myklebust@fys.uio.no
To: "Matt Helsley" <matthltc@us.ibm.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       "Linux Containers" <containers@lists.linux-foundation.org>,
       linux-nfs@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       "Chuck Lever" <chuck.lever@oracle.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Linux Containers" <containers@lists.osdl.org>,
       "Cedric Le Goater" <clg@fr.ibm.com>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: D4942E183FD332EAA81E16FEC09F48A23F1244DC
X-UiO-SPAM-Test: remote_host: 129.240.4.215 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 35 total 681076 max/h 707 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-06 at 16:08 -0800, Matt Helsley wrote:
> IMHO This seems more incorrect than trying to use a more proximal
namespace.

You have yet to explain why.




