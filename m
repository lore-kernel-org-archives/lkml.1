Return-Path: <linux-kernel-owner+w=401wt.eu-S1757416AbYGTMm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416AbYGTMm1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 08:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756677AbYGTMmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 08:42:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756676AbYGTMmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 08:42:19 -0400
Date: Sun, 20 Jul 2008 08:42:14 -0400
From: Alexander Viro <aviro@redhat.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <aviro@redhat.com>,
       dushistov@mail.ru
Subject: Re: [RFC] parser: add const to parser token table
Message-ID: <20080720124214.GA29735@devserv.devel.redhat.com>
References: <1216300972.4011.291.camel@quoit>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216300972.4011.291.camel@quoit>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 02:22:52PM +0100, Steven Whitehouse wrote:
> Hi,
> 
> Any objections to the following patch? If not I'll send it on to Linus.
> 
> This patch adds a "const" to the parser token table. I've done an
> allmodconfig build to see if this produces any warnings/failures and the
> patch includes a fix for the only warning that was produced.
> 
> Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
> Cc: Alexander Viro <aviro@redhat.com>
> Cc: Evgeniy Dushistov <dushistov@mail.ru>

ACK
