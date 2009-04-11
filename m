Return-Path: <linux-kernel-owner+w=401wt.eu-S1758502AbZDKUS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758502AbZDKUS6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 16:18:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756695AbZDKUSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 16:18:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:46927 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756649AbZDKUSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 16:18:49 -0400
Date: Sat, 11 Apr 2009 13:20:33 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Cc: linux-kernel@vger.kernel.org, tiwai@suse.de, alsa-devel@vger.kernel.org
Subject: Re: General protection fault when unloading snd_hda_intel on
 2.6.30-rc1+
Message-ID: <20090411132033.003c581c@infradead.org>
In-Reply-To: <20090411193630.GA16968@Pilar.aei.mpg.de>
References: <20090411193630.GA16968@Pilar.aei.mpg.de>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Apr 2009 21:36:30 +0200
"Carlos R. Mafra" <crmafra2@gmail.com> wrote:

> general protection fault:

Hi,

if you happen to have CONFIG_DEBUG_INFO enabled, then you can run the
oops through scripts/markup_oops.pl to get the source code of the exact
line that is oopsing.. makes diagnosing it even easier!



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
