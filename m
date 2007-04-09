Return-Path: <linux-kernel-owner+w=401wt.eu-S1753336AbXDIOUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbXDIOUO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 10:20:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbXDIOUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 10:20:14 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:59993 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336AbXDIOUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 10:20:12 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17946.19347.748203.428318@smtp.charter.net>
Date: Mon, 9 Apr 2007 10:20:03 -0400
From: "John Stoffel" <john@stoffel.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] Char: cyclades, remove volatiles
In-Reply-To: <46174825.4050509@gmail.com>
References: <16309194841640222796@karneval.cz>
	<25307199761334218148@karneval.cz>
	<20070406171406.317ea28a.akpm@linux-foundation.org>
	<46174825.4050509@gmail.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Jiri" == Jiri Slaby <jirislaby@gmail.com> writes:

Jiri> Andrew Morton napsal(a):
>> On Wed,  4 Apr 2007 23:45:38 +0200 (CEST) Jiri Slaby <jirislaby@gmail.com> wrote:
>> 
>>> cyclades, remove volatiles
>> 
>> The other changes seem uncontroversial, but this one has the potential
>> to change runtime behaviour.  And cyclades.c is a driver which some people
>> actually use ;)

Jiri> Well, don't you know anybody with Z card, please?

I've got an old Cyclom-Y card (ISA) that I use, should I bother trying
out your changes?

John
