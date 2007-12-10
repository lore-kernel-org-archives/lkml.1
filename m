Return-Path: <linux-kernel-owner+w=401wt.eu-S1757224AbXLJM7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224AbXLJM7t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 07:59:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755252AbXLJM7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 07:59:40 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:34111 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbXLJM7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 07:59:39 -0500
Date: Mon, 10 Dec 2007 13:59:38 +0100
To: Avi Kivity <avi@qumranet.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel BUG: Eeek! page_mapcount(page) went negative!
Message-ID: <20071210125938.GC25518@gamma.logic.tuwien.ac.at>
References: <20071210104859.GI7003@gamma.logic.tuwien.ac.at> <20071210112135.GA19783@gamma.logic.tuwien.ac.at> <475D37CE.8040602@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475D37CE.8040602@qumranet.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mo, 10 Dez 2007, Avi Kivity wrote:
> >kernel 2.6.24-rc4
> >kvm  55 (debian sid 55+dfsg-1)
> 
> Is the kvm kernel module pure 2.6.24-rc1, or are you running the kernel 
> module provided by kvm-55?

pure 2.6.24-rc4 (not -rc1), not the one by kvm-55.

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
STURRY (n.,vb.)
A token run. Pedestrians who have chosen to cross a road immediately
in front of an approaching vehicle generally give a little wave and
break into a sturry. This gives the impression of hurrying without
having any practical effect on their speed whatsoever.
			--- Douglas Adams, The Meaning of Liff
