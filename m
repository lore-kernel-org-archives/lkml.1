Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbXDJPDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbXDJPDb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 11:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753908AbXDJPDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 11:03:31 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:35199 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbXDJPDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 11:03:30 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17947.42811.199481.77296@smtp.charter.net>
Date: Tue, 10 Apr 2007 11:03:23 -0400
From: "John Stoffel" <john@stoffel.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: John Stoffel <john@stoffel.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] Char: cyclades, remove volatiles
In-Reply-To: <461B7855.9050500@gmail.com>
References: <16309194841640222796@karneval.cz>
	<25307199761334218148@karneval.cz>
	<20070406171406.317ea28a.akpm@linux-foundation.org>
	<46174825.4050509@gmail.com>
	<17946.19347.748203.428318@smtp.charter.net>
	<461B7855.9050500@gmail.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Jiri" == Jiri Slaby <jirislaby@gmail.com> writes:

>> I've got an old Cyclom-Y card (ISA) that I use, should I bother trying
>> out your changes?

Jiri> No, don't bother with these. If you are willing to test, please
Jiri> test next patchset -- I'll post it shortly. Or do you prefer
Jiri> external patched module?

Just post your patch and I'll try to get a test run done, which
shouldn't be too hard since my UPS daemon depends on the cyclom-Y
working right.

John
