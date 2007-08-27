Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbXH0NRG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbXH0NRG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 09:17:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbXH0NQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 09:16:56 -0400
Received: from smtp-03.mandic.com.br ([200.225.81.143]:43869 "EHLO
	smtp-03.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbXH0NQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 09:16:55 -0400
Message-ID: <46D2CEA9.1080106@mandic.com.br>
Date: Mon, 27 Aug 2007 10:16:25 -0300
From: "Renato S. Yamane" <renatoyamane@mandic.com.br>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Compiling 2.6.22.5 on Debian Etch (internal compiler error)
References: <46D1FA57.60601@mandic.com.br>
In-Reply-To: <46D1FA57.60601@mandic.com.br>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Renato S. Yamane escreveu:
> $ make xconfig
> HOSTCC  scripts/basic/fixdep
> scripts/basic/fixdep.c: In function ‘parse_dep_file’:
> scripts/basic/fixdep.c:399: internal compiler error: segmentation fault
> Please submit a full bug report,
> with preprocessed source if appropriate.
> See <URL:http://gcc.gnu.org/bugs.html> for instructions.
> For Debian GNU/Linux specific bug reporting instructions,
> see <URL:file:///usr/share/doc/gcc-4.1/README.Bugs>.
> Preprocessed source stored into /tmp/ccyzmUDF.out file, please attach 
> this to your bugreport.
> make[1]: ** [scripts/basic/fixdep] Error 1
> make: ** [scripts_basic] Error 2
> 
> Debian Etch R1.
> ccyzmUDF.out is attached.

I don't know why, but TODAY I can run "make xconfig" with no problems.

Regards,
Renato

