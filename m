Return-Path: <linux-kernel-owner+w=401wt.eu-S1757733AbZDFTiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733AbZDFTiV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 15:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757086AbZDFTiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 15:38:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757035AbZDFTiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 15:38:09 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Chris Evans <scarybeasts@gmail.com>,
       David Howells <dhowells@redhat.com>, Don Howard <dhoward@redhat.com>,
       Eugene Teo <eugene@redhat.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Tavis Ormandy <taviso@sdf.lonestar.org>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>
Subject: Re: [PATCH, RESEND] exit_notify: kill the wrong capable(CAP_KILL) check
In-Reply-To: Oleg Nesterov's message of  Monday, 6 April 2009 16:16:02 +0200 <20090406141602.GA17561@redhat.com>
References: <20090225190218.GA7453@redhat.com>
	<20090406141602.GA17561@redhat.com>
X-Windows: graphics hacking :: Roman numerals : sqrt (pi)
Message-Id: <20090406193609.6614CFC3E3@magilla.sf.frob.com>
Date: Mon,  6 Apr 2009 12:36:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>
