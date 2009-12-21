Return-Path: <linux-kernel-owner+w=401wt.eu-S1751782AbZLUHQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782AbZLUHQU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 02:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbZLUHQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 02:16:18 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:50982 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbZLUHQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 02:16:17 -0500
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Peter Hutterer <peter.hutterer@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: add multi-input quirk for NextWindow Touchscreen.
References: <20091203050810.GA26595@barra.bne.redhat.com>
	<87zl60s17o.fsf@macbook.be.48ers.dk> <4B1836A6.405@redhat.com>
	<871vjasxnm.fsf@macbook.be.48ers.dk> <4B190D88.4090102@redhat.com>
	<87ws12rh5j.fsf@macbook.be.48ers.dk> <4B1C96C4.5080709@redhat.com>
	<87hbs0mqju.fsf@macbook.be.48ers.dk> <4B2B0CCE.2020406@redhat.com>
	<87638239ha.fsf@macbook.be.48ers.dk> <4B2EB7E1.7090506@redhat.com>
Date: Mon, 21 Dec 2009 08:16:11 +0100
In-Reply-To: <4B2EB7E1.7090506@redhat.com> (Peter Hutterer's message of "Mon,
	21 Dec 2009 09:48:49 +1000")
Message-ID: <873a3423wk.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Peter" == Peter Hutterer <peter.hutterer@redhat.com> writes:

Hi,

 >> Ok, thanks for checking it all out! Just to be completely sure, the
 >> quirk doesn't cause any problems in mode 1/9, right?

 Peter> no, the evtest output looks the same with and without the quirk,
 Peter> including right button emulation on long press, etc.

Perfect, thanks!

-- 
Bye, Peter Korsgaard
