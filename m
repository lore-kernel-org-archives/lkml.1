Return-Path: <linux-kernel-owner+w=401wt.eu-S1755442AbYKVJ16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbYKVJ16 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 04:27:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752664AbYKVJ1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 04:27:47 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45571 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751072AbYKVJ1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 04:27:46 -0500
Date: Sat, 22 Nov 2008 01:27:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: htejun@gmail.com, arjan@linux.intel.com, torvalds@linux-foundation.org,
       hch@infradead.org, mingo@elte.hu, rminnich@sandia.gov, ericvh@gmail.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH fwd] poll: allow f_op->poll to sleep
Message-Id: <20081122012722.e1ac2698.akpm@linux-foundation.org>
In-Reply-To: <E1L3oK1-0001Pz-J9@pomaz-ex.szeredi.hu>
References: <E1L3oK1-0001Pz-J9@pomaz-ex.szeredi.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Nov 2008 09:58:33 +0100 Miklos Szeredi <miklos@szeredi.hu> wrote:

> Andrew, can you please apply this?

I did so earlier today.
