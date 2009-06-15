Return-Path: <linux-kernel-owner+w=401wt.eu-S1765769AbZFOUas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765769AbZFOUas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 16:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbZFOUaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 16:30:35 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43456 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbZFOUae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 16:30:34 -0400
Date: Mon, 15 Jun 2009 16:18:31 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, greg@kroah.com,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       tshibata@ab.jp.nec.com
Subject: Re: [RFC] Documentation: add documentation for rc-series and merge
	window
Message-ID: <20090615201830.GI2729@tuxdriver.com>
References: <1245096771-3966-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245096771-3966-1-git-send-email-lrodriguez@atheros.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 04:12:51PM -0400, Luis R. Rodriguez wrote:

> I was also not sure if Documentation/stable_kernel_rules.txt is the best
> splace for this as well, please let me know.

I'm pretty sure it needs to be somewhere else.  The -stable release
timing is basically unrelated to what your text discusses.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
