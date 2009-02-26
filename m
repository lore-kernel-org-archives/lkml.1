Return-Path: <linux-kernel-owner+w=401wt.eu-S1753549AbZBZA3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbZBZA3j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 19:29:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbZBZA3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 19:29:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49639 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751435AbZBZA33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 19:29:29 -0500
Date: Wed, 25 Feb 2009 16:28:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Malicki <jmalicki@metacarta.com>
Cc: linux-kernel@vger.kernel.org, jmalicki@metacarta.com,
       bakerkj@metacarta.com, mitz@metacarta.com
Subject: Re: BUG: setuid sometimes doesn't.
Message-Id: <20090225162836.63fce3c4.akpm@linux-foundation.org>
In-Reply-To: <9683328.9717571235603514325.JavaMail.root@ouachita>
References: <10783026.9717361235603356623.JavaMail.root@ouachita>
	<9683328.9717571235603514325.JavaMail.root@ouachita>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Feb 2009 18:11:54 -0500 (EST)
Joe Malicki <jmalicki@metacarta.com> wrote:
>

wow, good bug report!

> 
> Very rarely, we experience a setuid program not properly getting
> the euid of its owner.

Do you know which euid it _does_ get?  Is it unchanged, or is it random
garbage, or...?


