Return-Path: <linux-kernel-owner+w=401wt.eu-S1758509AbXLSXyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758509AbXLSXyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 18:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbXLSXyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 18:54:05 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52303 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754210AbXLSXyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 18:54:02 -0500
Date: Wed, 19 Dec 2007 15:53:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Trevor Highland <thighlan@gmail.com>
Cc: linux-kernel@vger.kernel.org, ecryptfs-devel@lists.sourceforge.net,
       mhalcrow@us.ibm.com
Subject: Re: [PATCH] eCryptfs: Change the type of cipher_code from u16 to u8
Message-Id: <20071219155324.ad2ea045.akpm@linux-foundation.org>
In-Reply-To: <1198032282.6015.12.camel@buster2>
References: <1198032282.6015.12.camel@buster2>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Dec 2007 20:44:42 -0600
Trevor Highland <thighlan@gmail.com> wrote:

> Change the type of cipher_code from u16 to u8.

I sure hope that Michael knows what's going on here, because these
changelogs aren't very useful.  They tell us *what* the patch does (which
was pretty obvious anyway) but they don't tell use *why* it was done.

The patches were rather wordwrapped so a resend would be needed anyway
please.    Some improved changelogging at the same time would be nice.
