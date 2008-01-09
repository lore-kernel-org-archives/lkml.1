Return-Path: <linux-kernel-owner+w=401wt.eu-S1754467AbYAIPkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467AbYAIPkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 10:40:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbYAIPk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 10:40:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40304 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbYAIPk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 10:40:26 -0500
To: Folkert van Heusden <folkert@vanheusden.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Fw: G965 & on-board serial port
From: Andi Kleen <andi@firstfloor.org>
References: <20080109130242.GD8331@vanheusden.com>
Date: Wed, 09 Jan 2008 16:40:25 +0100
In-Reply-To: <20080109130242.GD8331@vanheusden.com> (Folkert van Heusden's message of "Wed\, 9 Jan 2008 14\:02\:42 +0100")
Message-ID: <p73d4sbovme.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folkert van Heusden <folkert@vanheusden.com> writes:

> (no-one with a g965 mobo who uses the serial port?)

I do.

The typical problem is to use the wrong connector -- there
are three different ones floating around, but all fit on the
same pins on the motherboard.

Has nothing to do with Linux of course, but I suppose this
becomes more and more linux-random-talk anyways.

-Andi
