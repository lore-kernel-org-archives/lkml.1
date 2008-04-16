Return-Path: <linux-kernel-owner+w=401wt.eu-S1762863AbYDPLDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762863AbYDPLDX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 07:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758561AbYDPLCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 07:02:55 -0400
Received: from ug-out-1516.google.com ([66.249.92.164]:24498 "EHLO
	ug-out-1516.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757986AbYDPLCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 07:02:54 -0400
MIME-Version: 1.0
Message-ID: <db1091b2-68a6-4f71-800e-c4df6f8641ca@m44g2000hsc.googlegroups.com>
Date: Wed, 16 Apr 2008 04:02:51 -0700 (PDT)
In-Reply-To: <ajd42-7Gt-49@gated-at.bofh.it>
X-IP: 86.53.68.233
References: <ajbvb-3Ur-21@gated-at.bofh.it> <ajd42-7Gt-49@gated-at.bofh.it>
User-Agent: G2/1.0
X-HTTP-UserAgent: Mozilla/5.0 (X11; U; x86_64 Linux; en_GB; rv:1.8.0.4) 
	Gecko/20060508 Firefox/1.5.0.4,gzip(gfe),gzip(gfe)
Subject: Re: RFC: Self-snapshotting in Linux
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
To: Scott Lovenberg <scott.lovenberg@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scott Lovenberg wrote:
> Peter Teoh wrote:
> Maybe you load up another kernel to handle the snapshot, and then hand
> the system back to it afterwards?  What do you think?

Isn't that just what Ying Huans kexec-based hibernation does?
