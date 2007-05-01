Return-Path: <linux-kernel-owner+w=401wt.eu-S1423393AbXEAAfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423393AbXEAAfh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 20:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423405AbXEAAfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 20:35:37 -0400
Received: from khc.piap.pl ([195.187.100.11]:50226 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423393AbXEAAfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 20:35:36 -0400
To: Andrew Wang <andrewxwang@yahoo.com.tw>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Why ask Sun for ZFS while we have ReiserFS4 !?
References: <660658.6960.qm@web73512.mail.tp2.yahoo.com>
	<20070430085948.GC3701@merlin.emma.line.org>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 01 May 2007 02:35:34 +0200
In-Reply-To: <20070430085948.GC3701@merlin.emma.line.org> (Matthias Andree's message of "Mon, 30 Apr 2007 10:59:48 +0200")
Message-ID: <m31wi1qt2h.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthias Andree <matthias.andree@gmx.de> writes:

> Reiser4 doesn't appear to work anywhere except with Linux AFAICT, and
> being able to move storage between operating systems sure looks
> interesting...

Not very, actually, unless you're thinking about "portable" devices
which use things like FAT16 for max compatibility.
-- 
Krzysztof Halasa
