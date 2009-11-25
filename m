Return-Path: <linux-kernel-owner+w=401wt.eu-S1758424AbZKYHw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424AbZKYHw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 02:52:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbZKYHw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 02:52:26 -0500
Received: from tundra.namei.org ([65.99.196.166]:37457 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539AbZKYHwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 02:52:24 -0500
Date: Wed, 25 Nov 2009 18:52:27 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TOMOYO: Add recursive directory matching operator
 support.
In-Reply-To: <200911242200.AFC90128.FFJtHLOFVMQSOO@I-love.SAKURA.ne.jp>
Message-ID: <alpine.LRH.2.00.0911251852060.8855@tundra.namei.org>
References: <200911242200.AFC90128.FFJtHLOFVMQSOO@I-love.SAKURA.ne.jp>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Nov 2009, Tetsuo Handa wrote:

> TOMOYO 1.7.1 has recursive directory matching operator support.
> I want to add it to TOMOYO for Linux 2.6.33 .
> ----------
> [PATCH] TOMOYO: Add recursive directory matching operator support.
> 
> This patch introduces new operator /\{dir\}/ which matches
> '/' + 'One or more repetitions of dir/' (e.g. /dir/ /dir/dir/ /dir/dir/dir/ ).
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>


Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next


-- 
James Morris
<jmorris@namei.org>
