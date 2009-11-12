Return-Path: <linux-kernel-owner+w=401wt.eu-S1759962AbZKLCSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759962AbZKLCSj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 21:18:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759915AbZKLCSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 21:18:38 -0500
Received: from ozlabs.org ([203.10.76.45]:52795 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759907AbZKLCSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 21:18:37 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCHv9 3/3] vhost_net: a kernel-level virtio server
Date: Thu, 12 Nov 2009 12:48:37 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       linux-mm@kvack.org, akpm@linux-foundation.org, hpa@zytor.com,
       gregory.haskins@gmail.com, s.hetze@linux-ag.com,
       Daniel Walker <dwalker@fifo99.com>,
       Eric Dumazet <eric.dumazet@gmail.com>
References: <cover.1257786516.git.mst@redhat.com> <200911101349.09783.rusty@rustcorp.com.au> <20091110113637.GB6989@redhat.com>
In-Reply-To: <20091110113637.GB6989@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911121248.38365.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Nov 2009 10:06:37 pm Michael S. Tsirkin wrote:
> If tun is a module, vhost must be a module, too.
> If tun is built-in or disabled, vhost can be built-in.

I really like the brainbending :)  Keeps readers on their toes...

Applied,
Rusty.
