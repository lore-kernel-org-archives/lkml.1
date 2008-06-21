Return-Path: <linux-kernel-owner+w=401wt.eu-S1753011AbYFUXWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011AbYFUXWQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 19:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbYFUXWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 19:22:05 -0400
Received: from [194.117.236.238] ([194.117.236.238]:45457 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbYFUXWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 19:22:04 -0400
Date: Sun, 22 Jun 2008 02:21:19 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: tzanussi@gmail.com, penberg@cs.helsinki.fi, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, compudj@krystal.dyndns.org,
       vegard.nossum@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Unignore vmlinux.lds.h from Git.
Message-ID: <20080622022119.56866e13@linux360.ro>
In-Reply-To: <20080621171027.3e4542d6@linux360.ro>
References: <20080621171027.3e4542d6@linux360.ro>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jun 2008 17:10:27 +0300
Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro> wrote:

> Added !vmlinux.lds.h to .gitignore because it would otherwise be
> ignored.
> 
> Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Already merged in the last Linux release candidate, v2.6.26-rc7. In
case you want to test the other two patches, you could just rebase on
top of this last rc.


	Eduard
