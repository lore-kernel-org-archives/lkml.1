Return-Path: <linux-kernel-owner+w=401wt.eu-S1754071AbYKBW5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbYKBW5s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 17:57:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbYKBW5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 17:57:39 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:39743 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbYKBW5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 17:57:38 -0500
Date: Sun, 2 Nov 2008 16:57:35 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] integrity: Linux Integrity Module(LIM)
Message-ID: <20081102225735.GA10959@us.ibm.com>
References: <cover.1223869200.git.zohar@localhost.localdomain> <7c05f813215804a30d03821fd8e251b250d0e000.1223869200.git.zohar@localhost.localdomain> <1225471251.12673.408.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225471251.12673.408.camel@nimitz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Dave Hansen (dave@linux.vnet.ibm.com):
> On Mon, 2008-10-13 at 13:17 -0400, Mimi Zohar wrote:
> > Concern was raised on the lkml mailing list, about adding i_integrity
> > to the inode structure.  This patch adds a comment clarifying that
> > i_integrity is only included in the inode if INTEGRITY is configured.
> 
> Mimi, it is nice that you made this a config option.  That definitely
> helps the embedded folks and those compiling their own kernels.  But, it
> doesn't really help those who run distros.

Ah, of course, that makes sense - thanks for the reminder.  That answers
my earlier stupid question.

-serge
