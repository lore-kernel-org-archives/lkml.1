Return-Path: <linux-kernel-owner+w=401wt.eu-S1755965AbZKDM74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbZKDM74 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 07:59:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755891AbZKDM7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 07:59:55 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36803 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755743AbZKDM7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 07:59:55 -0500
Date: Wed, 4 Nov 2009 13:59:57 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, netdev@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, linux-mm@kvack.org,
       akpm@linux-foundation.org
Subject: Re: [PATCHv7 3/3] vhost_net: a kernel-level virtio server
Message-ID: <20091104125957.GL31511@one.firstfloor.org>
References: <cover.1257267892.git.mst@redhat.com> <20091103172422.GD5591@redhat.com> <878wema6o0.fsf@basil.nowhere.org> <20091104121009.GF8398@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091104121009.GF8398@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Fine?

I cannot say -- are there paths that could drop the device beforehand?
(as in do you hold a reference to it?)

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
