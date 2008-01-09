Return-Path: <linux-kernel-owner+w=401wt.eu-S1754998AbYAIOEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998AbYAIOEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 09:04:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbYAIOE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 09:04:28 -0500
Received: from one.firstfloor.org ([213.235.205.2]:48484 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbYAIOE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 09:04:28 -0500
Date: Wed, 9 Jan 2008 15:06:59 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Junio C Hamano <junio@pobox.com>, Andi Kleen <andi@firstfloor.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       apw@shadowen.org
Subject: Re: [JANITOR PROPOSAL] Switch ioctl functions to ->unlocked_ioctl
Message-ID: <20080109140659.GA12923@one.firstfloor.org>
References: <20080108164015.GC31504@one.firstfloor.org> <20080109004748.GI2117@one.firstfloor.org> <7vir23jp3e.fsf@gitster.siamese.dyndns.org> <200801091255.02172.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801091255.02172.arnd@arndb.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, very good point. Does checkpatch.pl enforce diff -p already?
> If not, should it?

I don't think it should. That would reject a lot of perfectly good
patches.

-Andi
