Return-Path: <linux-kernel-owner+w=401wt.eu-S1755335AbYDWR4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbYDWR4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 13:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbYDWR4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 13:56:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46557 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbYDWR4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 13:56:07 -0400
Date: Wed, 23 Apr 2008 18:55:55 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Roland Dreier <rdreier@cisco.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] VFS patches (third series, mountinfo merge)
Message-ID: <20080423175555.GA15214@ZenIV.linux.org.uk>
References: <20080423002219.GW27459@ZenIV.linux.org.uk> <20080423163509.GZ27459@ZenIV.linux.org.uk> <ada7ieobh85.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ada7ieobh85.fsf@cisco.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2008 at 10:42:34AM -0700, Roland Dreier wrote:
> Just curious... do you plan to merge your changes to anon_inodes for
> 2.6.26?

As soon as kvm.git gets merged...
