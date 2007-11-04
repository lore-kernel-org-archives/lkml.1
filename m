Return-Path: <linux-kernel-owner+w=401wt.eu-S1757852AbXKDNgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852AbXKDNgy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 08:36:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755904AbXKDNgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 08:36:45 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:36315 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167AbXKDNgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 08:36:45 -0500
Date: Sun, 4 Nov 2007 06:36:43 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Massive slowdown when re-querying large nfs dir
Message-ID: <20071104133642.GS15111@parisc-linux.org>
References: <200711050758.38090.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711050758.38090.a1426z@gawab.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2007 at 07:58:38AM +0300, Al Boldi wrote:
> Any ideas?

How about tcpdumping and seeing what requests are flowing across the
wire?  You might be able to figure out what's being done differently.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
