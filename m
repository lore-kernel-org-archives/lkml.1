Return-Path: <linux-kernel-owner+w=401wt.eu-S933315AbXHPK2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933315AbXHPK2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 06:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760594AbXHPK2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 06:28:41 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:48324 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760156AbXHPK2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 06:28:40 -0400
To: Jan Blunck <jblunck@suse.de>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       opensuse-kernel@opensuse.org, opensuse@opensuse.org
Subject: Re: Testing the Current Upstream Kernel
References: <s2ihcn1vwob.fsf@totally-fudged-out-message-id>
From: Susanne Oberhauser <froh@novell.com>
Date: 16 Aug 2007 12:28:34 +0200
In-Reply-To: <s2ihcn1vwob.fsf@totally-fudged-out-message-id>
Message-ID: <s2iwsvvlqnh.fsf@byron.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Blunck <jblunck@suse.de> writes:

> With our openSUSE Build Service we build a daily kernel, where we take
> nightly snapshots of the current upstream development kernel (Linus' kernel
> tree linux-2.6.git) without any patches (besides those we need for building a
> RPM).  We do call this the vanilla kernel. It can be downloaded from:
> 
>  http://download.opensuse.org/repositories/Kernel:/Vanilla/SUSE_Factory/

Would it make sense to build it for the other distros as well?  like
debian, fedora and mandrake?  I mena in _theory_ we could build it for
those distros in the build server, couldn't we?


S.

-- 
Susanne Oberhauser    +49-911-74053-574   SUSE -- a Novell Business
Partner Engineering                       Maxfeldstraße 5
developer.novell.com                      90409 Nürnberg
SUSE LINUX GmbH, GF: Volker Smid, HRB 21284 (AG Nürnberg)
