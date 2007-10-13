Return-Path: <linux-kernel-owner+w=401wt.eu-S1762543AbXJMSUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762543AbXJMSUB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 14:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760536AbXJMSTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 14:19:44 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43370 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758097AbXJMSTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 14:19:42 -0400
Date: Sat, 13 Oct 2007 19:19:33 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Theodore Tso <tytso@mit.edu>, David Howells <dhowells@redhat.com>,
       kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/52] Introduce credential record
Message-ID: <20071013181933.GJ8181@ftp.linux.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk> <20071013181137.GA9051@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071013181137.GA9051@thunk.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 13, 2007 at 02:11:37PM -0400, Theodore Tso wrote:
> Hi David,
> 
>    I'm going to ask a stupid question, and I probably missed something
> in the 52 patches, but....  I see how the credential is used to do
> access checks, but why does the credentials record need to passed all
> the way into block allocator?  What is it used for there?

"5% are reserved for root"
