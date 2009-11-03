Return-Path: <linux-kernel-owner+w=401wt.eu-S1753203AbZKCMAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbZKCMAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 07:00:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbZKCMAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 07:00:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbZKCMAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 07:00:46 -0500
Date: Tue, 3 Nov 2009 13:57:12 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       linux-mm@kvack.org, akpm@linux-foundation.org, hpa@zytor.com,
       gregory.haskins@gmail.com, Rusty Russell <rusty@rustcorp.com.au>,
       s.hetze@linux-ag.com
Subject: Re: [PATCHv6 3/3] vhost_net: a kernel-level virtio server
Message-ID: <20091103115712.GE3375@redhat.com>
References: <cover.1257193660.git.mst@redhat.com> <20091102222904.GD15184@redhat.com> <1257206758.11429.70.camel@c-dwalke-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257206758.11429.70.camel@c-dwalke-linux.qualcomm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 04:05:58PM -0800, Daniel Walker wrote:
> 
> Random style issues below .. Part of this is just stuff checkpatch
> found.

Thanks very much, I'll fix these.
