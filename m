Return-Path: <linux-kernel-owner+w=401wt.eu-S1755951AbYGAMGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951AbYGAMGp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 08:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbYGAMGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 08:06:34 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:44719 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbYGAMGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 08:06:33 -0400
Date: Tue, 1 Jul 2008 14:06:32 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, Roland McGrath <roland@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Various x86 syscall mechanisms
In-Reply-To: <485C4B0E.2090704@zytor.com>
Message-ID: <alpine.LNX.1.10.0807011402450.12878@fbirervta.pbzchgretzou.qr>
References: <485C2875.2050204@goop.org> <485C4B0E.2090704@zytor.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Saturday 2008-06-21 02:27, H. Peter Anvin wrote:
>
> There is no reason we couldn't do syscall for 32-bit native, but the only
> processor that would benefit would be K7, and that's far enough in the past
> that I don't think anyone cares enough.

Well if it gives a speed improvement, I'd certainly care.
I do not see a reason why I should throw away the K7 if it still works,
even after 5 years lifetime.
