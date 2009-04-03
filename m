Return-Path: <linux-kernel-owner+w=401wt.eu-S1761217AbZDCAJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761217AbZDCAJy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 20:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755899AbZDCAJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 20:09:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56753 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345AbZDCAJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 20:09:44 -0400
Date: Thu, 2 Apr 2009 17:09:39 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: EXT4-ish "fixes" in UBIFS 
In-Reply-To: <49CCCB0A.6070701@nokia.com>
Message-ID: <alpine.DEB.2.01.0904021706330.6162@bogon.housecafe.de>
References: <49CCCB0A.6070701@nokia.com>
User-Agent: Alpine 2.01 (DEB 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1/iOYFGer0oTjYfuflxGunMEz+OCGzKRq50gC/
 silWgTUMNQsiQsF6AwFpJjZnX7WYOHqSjNhMwfLRUImmxrh8Nb
 30g2yfQglmFdCO3b9bJgQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Mar 2009, Artem Bityutskiy wrote:
> They just say - this is file-system bug, it is fixed in
> ext4 now, just fix the bug in UBIFS.

Would *mounting* the filesystem with "-o sync" help? This way no 
filesystem "fixes" are needed and userland would not have to be rewritten.

Christian.
-- 
Alice and Bob met for the first time at Bruce Schneier's pool-party
