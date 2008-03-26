Return-Path: <linux-kernel-owner+w=401wt.eu-S1759509AbYCZT4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759509AbYCZT4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 15:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755585AbYCZT4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 15:56:15 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:40938 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382AbYCZT4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 15:56:14 -0400
Date: Wed, 26 Mar 2008 16:56:12 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: Chris Wright <chrisw@sous-sol.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org, serge@hallyn.com
Subject: Re: Linux 2.6.24.4
Message-ID: <20080326165612.7266a7e8@mandriva.com.br>
In-Reply-To: <20080324191546.GK23462@sequoia.sous-sol.org>
References: <20080324191546.GK23462@sequoia.sous-sol.org>
Organization: Mandriva
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 24 Mar 2008 12:15:46 -0700
Chris Wright <chrisw@sous-sol.org> escreveu:

| We (the -stable team) are announcing the release of the 2.6.24.4
| kernel.

[...]

| Serge E. Hallyn (1):
|       file capabilities: simplify signal check

 Sorry for being late on this, but if I'm not missing something
I think you forgot to apply the 2.6.24.4 version of commit
aedb60a67c10a0861af179725d060765262ba0fb (Linus' tree) that
Serge has submitted to @stable some days ago.

 It fixes the at breakage bug which is still present in
2.6.24.4.

-- 
Luiz Fernando N. Capitulino
