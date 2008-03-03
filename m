Return-Path: <linux-kernel-owner+w=401wt.eu-S1761260AbYCCEIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761260AbYCCEIb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 23:08:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbYCCEIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 23:08:21 -0500
Received: from ozlabs.org ([203.10.76.45]:52158 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753153AbYCCEIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 23:08:20 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Amit Shah" <amitshah@gmx.net>
Subject: Re: [PATCH] VIRTIO NET: Enable netpoll interface for netconsole logging
Date: Mon, 3 Mar 2008 15:08:17 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
References: <877aabc40802290254k2ecc559at2a3bc9740cd82ebc@mail.gmail.com>
In-Reply-To: <877aabc40802290254k2ecc559at2a3bc9740cd82ebc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803031508.18063.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 February 2008 21:54:50 Amit Shah wrote:
> Add a new poll_controller handler that the netpoll interface needs.
>
> This enables netconsole logging from a kvm guest over the virtio
> net interface.
>
> Signed-off-by: Amit Shah <amitshah@gmx.net>

Wow, does this actually work?

If so, I'll apply it no problems...
Rusty.
