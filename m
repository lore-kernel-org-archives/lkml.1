Return-Path: <linux-kernel-owner+w=401wt.eu-S1758860AbXJaPDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758860AbXJaPDU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 11:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756960AbXJaPDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 11:03:13 -0400
Received: from mcclure-nat.wal.novell.com ([130.57.22.22]:19688 "EHLO
	mcclure.wal.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755726AbXJaPDM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 11:03:12 -0400
Message-Id: <472860980200005A0002D08F@mcclure.wal.novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Wed, 31 Oct 2007 11:03:01 -0400
From: "Gregory Haskins" <ghaskins@novell.com>
To: <greg@kroah.com>, <cebbert@redhat.com>
Cc: <mingo@elte.hu>, <peterz@infradead.org>, <stable@kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [stable] [PATCH] lockdep: fix mismatched
	lockdep_depth/curr_chain_hash
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Greg KH <greg@kroah.com> 10/31/07 10:37 AM >>>
>It does not apply to 2.6.22 at all, so unless someone sends us a
>backported version, I'll not apply it there.

Ill take care of this for you, Greg.

-Greg

