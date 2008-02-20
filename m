Return-Path: <linux-kernel-owner+w=401wt.eu-S934612AbYBTWBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934612AbYBTWBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 17:01:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757573AbYBTWBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 17:01:38 -0500
Received: from Mycroft.westnet.com ([216.187.52.7]:52350 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432AbYBTWBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 17:01:37 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18364.41753.194174.253318@stoffel.org>
Date: Wed, 20 Feb 2008 17:00:57 -0500
From: "John Stoffel" <john@stoffel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "John Stoffel" <john@stoffel.org>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cyclades: Prepare for relaxed locking in callers
In-Reply-To: <20080220214847.1a5590c3@core>
References: <20080220201216.40d70747@core>
	<18364.39445.347911.402466@stoffel.org>
	<20080220214847.1a5590c3@core>
X-Mailer: VM 8.0.x-xemacs-542 under Emacs 22.1.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Alan" == Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

Alan> On Wed, 20 Feb 2008 16:22:29 -0500
Alan> "John Stoffel" <john@stoffel.org> wrote:

>> 
Alan> Basically wrap it in lock_kernel where it is hard to prove the
Alan> locking is ok.
>> 
>> I've got cyclades cards, both ISA and Serial.  Do you want/need any
>> specific tests?  Or should I just send you (or your deputy) the ISA
>> card for your collection?

Alan> At the moment its fairly tricky to test unless you want to hack
Alan> your tree up further. The patch prepares for stuff that I've not
Alan> yet sent Andrew. I want to make sure we haven't broken anything
Alan> before sending the small patches to fire it all up.

Ok, please feel free to keep me in mind for testing. I've still got
ISA box(en) here up and running and being used.  As well as my
Cyclom-Y PCI card in actual use still.

John

