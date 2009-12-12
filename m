Return-Path: <linux-kernel-owner+w=401wt.eu-S1757407AbZLMCUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407AbZLMCUq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 21:20:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754284AbZLMCUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 21:20:45 -0500
Received: from casper.infradead.org ([85.118.1.10]:56804 "HELO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753072AbZLMCUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 21:20:44 -0500
Date: Sat, 12 Dec 2009 13:47:25 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] suspend: add initcall_debug style timing for
 suspend/resume
Message-ID: <20091212134725.6549ac2e@infradead.org>
In-Reply-To: <200912121927.55186.rjw@sisk.pl>
References: <20091206123552.7be316b2@infradead.org>
	<200912121927.55186.rjw@sisk.pl>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Dec 2009 19:27:55 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> I've changed that "initcall" to "call".  Hopefully that won't break
> your scripts. ;-)

it will, but I can adjust them no big deal



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
