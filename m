Return-Path: <linux-kernel-owner+w=401wt.eu-S1755363AbXKFHtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbXKFHtY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 02:49:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753069AbXKFHtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 02:49:17 -0500
Received: from cz-prg09a-av01.karneval.cz ([81.27.192.123]:14120 "EHLO
	av1.karneval.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbXKFHtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 02:49:16 -0500
X-Greylist: delayed 2017 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Nov 2007 02:49:16 EST
Date: Tue, 6 Nov 2007 08:15:27 +0100
From: Michal Schmidt <xschmi00@stud.feec.vutbr.cz>
To: "Zurk Tech" <zurktech@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Truecrypt in kernel ?
Message-ID: <20071106081527.409a0026@hammerfall>
In-Reply-To: <2ed59cbb0711051742k5e4a7858ie95126399006ba53@mail.gmail.com>
References: <2ed59cbb0711051742k5e4a7858ie95126399006ba53@mail.gmail.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Nov 2007 20:42:39 -0500
"Zurk Tech" <zurktech@gmail.com> wrote:
> just wondering why the truecrypt module isnt in the mainline kernel ?
> its the only cross platform encrypted disk solution out there and it
> should be less of a chore to use it in linux...is there something
> wrong with the truecrypt kernel driver ?

Two reasons:
The author hasn't sent patches.
It looks to me the license is incompatible with the GPLv2.

Michal
