Return-Path: <linux-kernel-owner+w=401wt.eu-S1754160AbYAPX6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbYAPX6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 18:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751513AbYAPX6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 18:58:11 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:50881 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbYAPX6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 18:58:09 -0500
Date: Thu, 17 Jan 2008 00:58:06 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Karel Zak <kzak@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, util-linux-ng@vger.kernel.org,
       linuxram@us.ibm.com, viro@ftp.linux.org.uk, hch@infradead.org,
       a.p.zijlstra@chello.nl
Subject: Re: [patch] VFS: extend /proc/mounts
In-Reply-To: <20080116234339.GG26049@petra.dvoda.cz>
Message-ID: <Pine.LNX.4.64.0801170057520.31385@fbirervta.pbzchgretzou.qr>
References: <E1JFGUp-00054z-KQ@pomaz-ex.szeredi.hu>
 <20080116143051.ec488f3d.akpm@linux-foundation.org> <20080116234339.GG26049@petra.dvoda.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 17 2008 00:43, Karel Zak wrote:
>> 
>> Seems like a plain bad idea to me.  There will be any number of home-made
>> /proc/mounts parsers and we don't know what they do.
>
> So, let's use /proc/mounts_v2  ;-)

Was not it like "don't use /proc for new things"?
