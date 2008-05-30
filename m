Return-Path: <linux-kernel-owner+w=401wt.eu-S1755270AbYE3XKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbYE3XKO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 19:10:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753856AbYE3XJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 19:09:59 -0400
Received: from phoenix.clifford.at ([88.198.7.52]:56265 "EHLO
	phoenix.clifford.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519AbYE3XJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 19:09:59 -0400
Date: Sat, 31 May 2008 00:50:32 +0200
From: Clifford Wolf <clifford@clifford.at>
To: Hugh Dickins <hugh@veritas.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add rlimits to /proc/<PID>/status
Message-ID: <20080530225032.GH1369@clifford.at>
References: <20080530201104.GG1369@clifford.at> <Pine.LNX.4.64.0805302232430.31527@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805302232430.31527@blonde.site>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, May 30, 2008 at 10:35:27PM +0100, Hugh Dickins wrote:
> Aren't they better staying in /proc/<PID>/limits?

this was a cleanup of a patch I've sent to lkml about 6 months ago
when there was no yet-released (non-rc) kernel with /proc/<PID>/limits ...

my patch is a more or less duplicate of commit d85f50d5. oops.
please simply ignore it..  ;-)

yours,
 - clifford

-- 
A byte walks into a bar and orders a pint. Bartender asks him "What's wrong?"
Byte says "Parity error." Bartender nods and says "Yeah, I thought you looked
a bit off."
