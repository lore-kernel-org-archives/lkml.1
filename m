Return-Path: <linux-kernel-owner+w=401wt.eu-S1760552AbYF0NGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760552AbYF0NGt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 09:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757909AbYF0NGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 09:06:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45060 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757454AbYF0NGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 09:06:34 -0400
Subject: Re: a.out.h userspace headers not present with O=
From: David Woodhouse <dwmw2@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: sam@ravnborg.org, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080627130236.GD18644@cs181140183.pp.htv.fi>
References: <20080627130236.GD18644@cs181140183.pp.htv.fi>
Content-Type: text/plain
Date: Fri, 27 Jun 2008 14:06:24 +0100
Message-Id: <1214571984.10393.193.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-06-27 at 16:02 +0300, Adrian Bunk wrote:
> Commit e53d6a152793a38aa334d6f7a4850642ae45cedc
> (Export <linux/a.out.h> to userspace again.)
> does not work properly when using O= :

Hm, I copied the logic from the existing condition in
include/asm-generic/Kbuild.asm. Does that not work either?

-- 
dwmw2

