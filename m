Return-Path: <linux-kernel-owner+w=401wt.eu-S1755059AbXKAUjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059AbXKAUjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 16:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753025AbXKAUjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 16:39:05 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36781 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751674AbXKAUjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 16:39:03 -0400
Date: Thu, 1 Nov 2007 13:38:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Zurk Tech" <zurktech@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Quad core CPU detected but shows as single core in 2.6.23.1
Message-Id: <20071101133856.d97ce4f0.akpm@linux-foundation.org>
In-Reply-To: <2ed59cbb0710250750w73d2b29dwee0f1038fa9dff18@mail.gmail.com>
References: <2ed59cbb0710250750w73d2b29dwee0f1038fa9dff18@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007 10:50:50 -0400
"Zurk Tech" <zurktech@gmail.com> wrote:

> duh. never mind. i had an attack of the stupids and enabled GART error
> reporting in the bios menu when i installed the motherboard. fixed
> now. shows all 4 and 8 on the other one.

Confused.  Why should that cause the kernel to misreport the core
count?
