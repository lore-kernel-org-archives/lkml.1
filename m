Return-Path: <linux-kernel-owner+w=401wt.eu-S1758188AbYHZOuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188AbYHZOuu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 10:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754848AbYHZOum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 10:50:42 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64292 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752309AbYHZOul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 10:50:41 -0400
Date: Tue, 26 Aug 2008 15:50:05 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Pavel Machek <pavel@suse.cz>
cc: Avi Kivity <avi@qumranet.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] x86: default to reboot via ACPI
In-Reply-To: <20080826141230.GA5478@ucw.cz>
Message-ID: <Pine.LNX.4.55.0808261546310.28361@cliff.in.clinika.pl>
References: <1219659087-17536-1-git-send-email-avi@qumranet.com>
 <20080826095032.GA309@elf.ucw.cz> <48B3D579.40502@qumranet.com>
 <20080826113317.520cbab1@lxorguk.ukuu.org.uk> <48B3F3A9.8030709@qumranet.com>
 <Pine.LNX.4.55.0808261406330.28361@cliff.in.clinika.pl> <48B40631.5090007@qumranet.com>
 <20080826141230.GA5478@ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2008, Pavel Machek wrote:

> reboot needs to work on servers-in-a-closet, too.

 More importantly even, I would say, as failing to do so will cost some a
drive to a remote location in the middle of the night on a weekend or some
holiday.

  Maciej
