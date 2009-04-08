Return-Path: <linux-kernel-owner+w=401wt.eu-S1761696AbZDHUdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761696AbZDHUdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 16:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756936AbZDHUdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 16:33:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754259AbZDHUdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 16:33:08 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Sergio Luis <eeeesti@gmail.com>
X-Fcc: ~/Mail/linus
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: checkpatch fixes
In-Reply-To: Sergio Luis's message of  Wednesday, 8 April 2009 04:26:08 -0300 <ce0170d90904080026x4e292ce7sfae4eea70eb386cd@mail.gmail.com>
References: <20090408062106.39EE0FC3E5@magilla.sf.frob.com>
	<ce0170d90904080026x4e292ce7sfae4eea70eb386cd@mail.gmail.com>
Emacs: no job too big... no job.
Message-Id: <20090408125037.549C1FC351@magilla.sf.frob.com>
Date: Wed,  8 Apr 2009 05:50:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> silly question, but... how do you verify that? is there any tool under
> scripts/ that do that comparison?

I didn't use any script, there might be done, I don't know.
I compared "objdump -rd" output on the .o file before and after, using diff.


Thanks,
Roland
