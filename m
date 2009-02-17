Return-Path: <linux-kernel-owner+w=401wt.eu-S1755107AbZBQXcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107AbZBQXcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 18:32:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753403AbZBQXcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 18:32:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58240 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751953AbZBQXcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 18:32:17 -0500
Date: Tue, 17 Feb 2009 15:31:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, x86@kernel.org
Subject: Re: mmotm 2009-02-17-12-33 uploaded
Message-Id: <20090217153136.a407c776.akpm@linux-foundation.org>
In-Reply-To: <499B465D.9080502@gmail.com>
References: <200902172050.n1HKorvc028933@imap1.linux-foundation.org>
	<499B465D.9080502@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Feb 2009 00:21:01 +0100
Jiri Slaby <jirislaby@gmail.com> wrote:

> I'm getting the page fault below everytime during bootup.

It'd be useful to know if bare linux-next does the same thing, please.
