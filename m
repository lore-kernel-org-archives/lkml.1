Return-Path: <linux-kernel-owner+w=401wt.eu-S1757457AbZFXVR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457AbZFXVR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 17:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755918AbZFXVRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 17:17:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56977 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435AbZFXVRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 17:17:49 -0400
Date: Wed, 24 Jun 2009 22:17:52 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: shmem_get_acl: unable to handle kernel paging request at
	ffffffffffffffff
Message-ID: <20090624211752.GY8633@ZenIV.linux.org.uk>
References: <200906242316.05073.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906242316.05073.elendil@planet.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 11:16:03PM +0200, Frans Pop wrote:
> I just tried v2.6.30-8722-gc82e6d4 on VirtualBox (x86_64) and got a crash.
> Last tested/working version: v2.6.30-6553-g65795ef.

Fixed in vfs-2.6.git for-linus...
