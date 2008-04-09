Return-Path: <linux-kernel-owner+w=401wt.eu-S1757082AbYDIPT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082AbYDIPT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 11:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756788AbYDIPTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 11:19:17 -0400
Received: from barikada.upol.cz ([158.194.242.200]:44380 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756636AbYDIPTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 11:19:16 -0400
Date: Wed, 9 Apr 2008 17:39:21 +0200
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kbuild devel list <linux-kbuild@vger.kernel.org>
Subject: Re: coloring stdout && stderr, small kbuild example
Message-ID: <20080409153920.GF24008@flower.upol.cz>
References: <E1Jjbol-0002zS-4P@flower>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Jjbol-0002zS-4P@flower>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forgot, email can be piped ('|' in mutt) to have script ready

to this line: sed '1,/^___/d' >/tmp/colorize-linux-build.sh'
--
sed 'sed && sh + olecom = love' << ''
http://kernelnewbies.org/olecom
-o--=O`C
 #oo'L O
<___=E M
