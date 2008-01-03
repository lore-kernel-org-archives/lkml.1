Return-Path: <linux-kernel-owner+w=401wt.eu-S1754584AbYACOLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbYACOLv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 09:11:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbYACOLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 09:11:34 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47458 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbYACOLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 09:11:34 -0500
Date: Thu, 3 Jan 2008 14:11:32 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: isofs oops - d_splice_alias+0x1f (2.6.24-rc5-mm1)
Message-ID: <20080103141132.GU27894@ZenIV.linux.org.uk>
References: <477CE1E0.4010504@gmail.com> <Pine.LNX.4.64.0801031550160.2076@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801031550160.2076@sbz-30.cs.Helsinki.FI>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2008 at 03:51:28PM +0200, Pekka J Enberg wrote:

> Does the following patch fix it?

Highly doubtful, and doesn't deal with the real problem, AFAICS...
