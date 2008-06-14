Return-Path: <linux-kernel-owner+w=401wt.eu-S1756068AbYFNVxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068AbYFNVxo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 17:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755099AbYFNVxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 17:53:34 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:57345 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755032AbYFNVxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 17:53:33 -0400
Date: Sat, 14 Jun 2008 23:23:41 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: =?unknown-8bit?B?U8OpZ3VpZXIgUsOpZ2lz?= <rseguier@e-teleport.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, alan@redhat.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: via-velocity.c fix sleep-with-spinlock bug during
	MTU change
Message-ID: <20080614212341.GA12976@electric-eye.fr.zoreil.com>
References: <20080531184615.350bac00@infradead.org> <20080603134019.df2f51d4.akpm@linux-foundation.org> <20080603215155.GA9712@electric-eye.fr.zoreil.com> <20080604215909.GA17446@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080604215909.GA17446@electric-eye.fr.zoreil.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francois Romieu <romieu@fr.zoreil.com> :
[...context available from http://lkml.org/lkml/2008/5/31/251 ...]

Régis, I need your help.

Can you give the patchkit below a try and check if the change of mtu
works correctly ?

http://userweb.kernel.org/~romieu/via-velocity/2.6.26-rc6/

or:

git://git.kernel.org/pub/scm/linux/kernel/git/romieu/netdev-2.6.git velocity

-- 
Ueimor
