Return-Path: <linux-kernel-owner+w=401wt.eu-S1759223AbYBOMUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759223AbYBOMUd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 07:20:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbYBOMUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 07:20:19 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742AbYBOMUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 07:20:07 -0500
Date: Fri, 15 Feb 2008 12:20:02 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Implement barrier support for single device DM devices
Message-ID: <20080215122002.GM29914@agk.fab.redhat.com>
Mail-Followup-To: Andi Kleen <andi@firstfloor.org>, dm-devel@redhat.com,
	linux-kernel@vger.kernel.org
References: <20080215120821.GA8267@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080215120821.GA8267@basil.nowhere.org>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 01:08:21PM +0100, Andi Kleen wrote:
> Implement barrier support for single device DM devices
 
Thanks.  We've got some (more-invasive) dm patches in the works that
attempt to use flushing to emulate barriers where we can't just
pass them down like that.

Alasdair
-- 
agk@redhat.com
