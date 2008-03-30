Return-Path: <linux-kernel-owner+w=401wt.eu-S1753901AbYC3LdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbYC3LdY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 07:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbYC3LdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 07:33:16 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:38498 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbYC3LdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 07:33:15 -0400
Date: Sun, 30 Mar 2008 15:33:04 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: David Fries <david@fries.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/35] W1: be able to manually add and remove slaves
Message-ID: <20080330113304.GG15122@2ka.mipt.ru>
References: <200803272343.m2RNhDac017650@SpacedOut.fries.net> <20080328122523.GK3613@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080328122523.GK3613@spacedout.fries.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2008 at 07:25:23AM -0500, David Fries (david@fries.net) wrote:
> w1.c 1.11 1.12 1.14
> I'm intending to be working with a static network and run without the
> bus searching, but bus searching is currently the only way to add
> slave devices.  This allows any slave to be added or removed.  There
> is one file for adding and another for removing.  If the files are
> read a short comment including the expected serial number format is
> returned.
> 
> Signed-off-by: David Fries <david@fries.net>

Ack.

-- 
	Evgeniy Polyakov
