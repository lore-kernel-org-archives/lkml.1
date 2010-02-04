Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933195Ab0BDQR7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 11:17:59 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:55626 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932504Ab0BDQR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 11:17:58 -0500
Date: Thu, 4 Feb 2010 11:17:35 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Rik van Riel <riel@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       aarcange@redhat.com, mtosatti@redhat.com
Subject: Re: [PATCH] emulate accessed bit for EPT
Message-ID: <20100204161735.GA8970@c2.user-mode-linux.org>
References: <20100203161103.11e2b572@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100203161103.11e2b572@annuminas.surriel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 03, 2010 at 04:11:03PM -0500, Rik van Riel wrote:
> Jeff, does this patch fix the issue you saw a few months ago, with
> a 256MB KVM guest in a cgroup limited to 128GB memory?

Hum, let me dust off that workload and give it a shot...

				Jeff
