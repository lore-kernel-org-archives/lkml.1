Return-Path: <linux-kernel-owner+w=401wt.eu-S1758337AbYHZKvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758337AbYHZKvL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 06:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754662AbYHZKu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 06:50:56 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41038 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758137AbYHZKuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 06:50:55 -0400
Date: Tue, 26 Aug 2008 11:33:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Avi Kivity <avi@qumranet.com>
Cc: Pavel Machek <pavel@suse.cz>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] x86: default to reboot via ACPI
Message-ID: <20080826113317.520cbab1@lxorguk.ukuu.org.uk>
In-Reply-To: <48B3D579.40502@qumranet.com>
References: <1219659087-17536-1-git-send-email-avi@qumranet.com>
	<20080826095032.GA309@elf.ucw.cz>
	<48B3D579.40502@qumranet.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It seems excessive.  Most machines will hardly run without acpi.

*Recent* machines.
