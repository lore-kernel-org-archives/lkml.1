Return-Path: <linux-kernel-owner+w=401wt.eu-S1756272AbYGVSrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272AbYGVSrg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 14:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbYGVSr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 14:47:27 -0400
Received: from namei.org ([69.55.235.186]:38597 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754417AbYGVSr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 14:47:26 -0400
Date: Wed, 23 Jul 2008 04:43:49 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Adrian Bunk <bunk@kernel.org>
cc: Eric Paris <eparis@redhat.com>, sds@tycho.nsa.gov,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make selinux_write_opts() static
In-Reply-To: <20080722172123.GX14846@cs181140183.pp.htv.fi>
Message-ID: <Xine.LNX.4.64.0807230443140.5985@us.intercode.com.au>
References: <20080722172123.GX14846@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2008, Adrian Bunk wrote:

> This patch makes the needlessly global selinux_write_opts() static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Thanks.

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#devel

-- 
James Morris
<jmorris@namei.org>
