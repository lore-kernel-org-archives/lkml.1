Return-Path: <linux-kernel-owner+w=401wt.eu-S1754966AbZG1Qkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966AbZG1Qkn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 12:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753522AbZG1Qkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 12:40:43 -0400
Received: from wf-out-1516.google.com ([209.85.200.160]:15755 "EHLO
	wf-out-1516.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbZG1Qkm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 12:40:42 -0400
MIME-Version: 1.0
Date: Tue, 28 Jul 2009 09:40:42 -0700 (PDT)
In-Reply-To: <ct4xS-63o-27@gated-at.bofh.it>
X-IP: 62.172.74.16
References: <ct4xS-63o-27@gated-at.bofh.it>
User-Agent: G2/1.0
X-HTTP-UserAgent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) 
	Gecko/20090716 Ubuntu/9.04 (jaunty) Shiretoko/3.5.1,gzip(gfe),gzip(gfe)
Message-ID: <ba6a8e0d-946b-4d69-9f70-991e93c18f90@o15g2000yqm.googlegroups.com>
Subject: Re: 2.6.28.9: EXT3/NFS inodes corruption
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Sylvain Rochet <gradator@gradator.net>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 20, 5:30 pm, Sylvain Rochet <grada...@gradator.net> wrote:
> Hi,
>
> We(TuxFamily) are having some inodes corruptions on a NFS server.
>
> So, let's start with the facts.
>
> ==== NFS Server
>
> Linux bazooka 2.6.28.9 #1 SMP Mon Mar 30 12:58:22 CEST 2009 x86_64 GNU/Linux
[snip]

Can you do a 'lspci -v' on the server please?

Daniel
--
Daniel J Blueman
