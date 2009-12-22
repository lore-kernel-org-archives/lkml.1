Return-Path: <linux-kernel-owner+w=401wt.eu-S1755010AbZLVUpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010AbZLVUpv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 15:45:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754757AbZLVUps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 15:45:48 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36953 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692AbZLVUps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 15:45:48 -0500
To: Soumendu Satapathy <satapathy.soumendu@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Oops in 2.6.27.39 with latest DTrace linux port
From: Andi Kleen <andi@firstfloor.org>
References: <b3eb0ed40912221226o56e4de26oc3119f3b0a946548@mail.gmail.com>
Date: Tue, 22 Dec 2009 21:45:43 +0100
In-Reply-To: <b3eb0ed40912221226o56e4de26oc3119f3b0a946548@mail.gmail.com> (Soumendu Satapathy's message of "Tue, 22 Dec 2009 15:26:11 -0500")
Message-ID: <87ljgud9fs.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Soumendu Satapathy <satapathy.soumendu@gmail.com> writes:

> Hi,
>
> http://lkml.org/lkml/2009/12/22/219
>
> Attaching the patch for the above:-

You need to send that to the dtrace for linux author,
strace is not in the mainline sources.

You could also encourage him/her to submit his patches for 
review.

-Andi
