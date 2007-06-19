Return-Path: <linux-kernel-owner+w=401wt.eu-S1756754AbXFSJfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754AbXFSJfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 05:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754035AbXFSJfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 05:35:11 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:9134 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034AbXFSJfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 05:35:09 -0400
Date: Tue, 19 Jun 2007 11:34:56 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Bastian Blank <bastian@waldi.eu.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [patch 5/6] Move psw_set_key.
Message-ID: <20070619093456.GB8684@osiris.boeblingen.de.ibm.com>
References: <20070619084516.457715754@de.ibm.com> <20070619084642.673859525@de.ibm.com> <20070619091200.GA1277@wavehammer.waldi.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070619091200.GA1277@wavehammer.waldi.eu.org>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 11:12:00AM +0200, Bastian Blank wrote:
> On Tue, Jun 19, 2007 at 10:45:21AM +0200, Martin Schwidefsky wrote:
> > Move psw_set_key() from ptrace.h to processor.h which is a more
> > suitable place for it. In addition the moves makes the function
> > invisible to user space.
> 
> Hmm, this does not really describe the changes.

Yes.. you need to interchange descriptions for patches 5 & 6. Then it
might make sense ;)
