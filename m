Return-Path: <linux-kernel-owner+w=401wt.eu-S1754534AbZFVIIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbZFVIIF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 04:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbZFVIHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 04:07:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60489 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbZFVIHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 04:07:50 -0400
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: Re: [PATCH 19/23] x86/oprofile: use 64 bit wrmsr functions
From: Andi Kleen <andi@firstfloor.org>
References: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
	<1244810140-20595-20-git-send-email-robert.richter@amd.com>
	<87my803dz0.fsf@basil.nowhere.org>
Date: Mon, 22 Jun 2009 10:07:51 +0200
In-Reply-To: <87my803dz0.fsf@basil.nowhere.org> (Andi Kleen's message of "Mon, 22 Jun 2009 09:49:23 +0200")
Message-ID: <87fxds3d48.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:
>
> I don't think if it causes real problems, but it looks suspicious.

s/think/know/

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
