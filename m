Return-Path: <linux-kernel-owner+w=401wt.eu-S1754625AbYIKDWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbYIKDWQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 23:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbYIKDWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 23:22:00 -0400
Received: from quackingmoose.com ([63.73.180.143]:52947 "EHLO
	penguin.merfinllc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752230AbYIKDWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 23:22:00 -0400
Date: Wed, 10 Sep 2008 20:21:59 -0700
From: Aaron Straus <aaron@merfinllc.com>
To: Todor Gyumyushev <todor@saturnosoft.biz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel bug
Message-ID: <20080911032159.GC7944@merfinllc.com>
References: <48C82F78.5050509@saturnosoft.biz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C82F78.5050509@saturnosoft.biz>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 10 11:35 PM, Todor Gyumyushev wrote:
> kernel BUG at drivers/char/random.c:728!

Hi,

  It's a race condition.  Andrew fixed it as of 2.6.26.4.

				Thanks,
				=a=

-- 
===================
Aaron Straus
aaron@merfinllc.com
