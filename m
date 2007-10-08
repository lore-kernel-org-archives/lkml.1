Return-Path: <linux-kernel-owner+w=401wt.eu-S1756581AbXJHTJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581AbXJHTJE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 15:09:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755027AbXJHTIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 15:08:54 -0400
Received: from vena.lwn.net ([206.168.112.25]:33523 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754656AbXJHTIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 15:08:53 -0400
To: Al Viro <viro@ftp.linux.org.uk>
Cc: mgross@linux.intel.com, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel@vger.kernel.org
Subject: Re: RFC: reviewer's statement of oversight 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Mon, 08 Oct 2007 20:05:15 BST."
             <20071008190515.GU8181@ftp.linux.org.uk> 
Date: Mon, 08 Oct 2007 13:08:52 -0600
Message-ID: <32082.1191870532@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ftp.linux.org.uk> wrote:

> > A patch which is not "worthwhile" is also not "appropriate".  Mere
> > correctness in a mathematical sense is not enough as technical review
> > criterion.
> 
> Yes, but there's also such thing as "worthwhile removal".

Good point.  So the text should probably say "worthwhile change" rather
than "worthwhile addition."  I do believe that thinking about whether
the change as a whole is a desirable thing is an important part of the
review process.

jon
