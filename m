Return-Path: <linux-kernel-owner+w=401wt.eu-S1755936AbXLJLVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbXLJLVz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 06:21:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754595AbXLJLVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 06:21:40 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:38373 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299AbXLJLVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 06:21:37 -0500
Date: Mon, 10 Dec 2007 12:21:35 +0100
To: linux-kernel@vger.kernel.org
Subject: Re: kernel BUG: Eeek! page_mapcount(page) went negative!
Message-ID: <20071210112135.GA19783@gamma.logic.tuwien.ac.at>
References: <20071210104859.GI7003@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071210104859.GI7003@gamma.logic.tuwien.ac.at>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mo, 10 Dez 2007, preining wrote:
> I was running a kvm installing windows, and eek it crashed happily my
> computer, probably because I forgot to give kvm -no-acpi option.

I forgot:

kernel 2.6.24-rc4
kvm  55 (debian sid 55+dfsg-1)

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
FLIMBY (n.)
One of those irritating handle-less slippery translucent plastic bags
you get in supermarkets which, no matter how you hold them, always
contrive to let something fall out.
			--- Douglas Adams, The Meaning of Liff
