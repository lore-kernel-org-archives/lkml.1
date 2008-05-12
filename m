Return-Path: <linux-kernel-owner+w=401wt.eu-S1759027AbYELGwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759027AbYELGwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 02:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755332AbYELGwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 02:52:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60153 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754724AbYELGwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 02:52:10 -0400
Date: Sun, 11 May 2008 23:51:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jesper Krogh <jesper@krogh.cc>
Cc: Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org,
       linux-nfs@vger.kernel.org
Subject: Re: Many open/close on same files yeilds
 "No such file or directory".
Message-Id: <20080511235129.8eed8894.akpm@linux-foundation.org>
In-Reply-To: <4827E67E.3050008@krogh.cc>
References: <4819E316.7000607@krogh.cc>
	<4823DFA6.9010504@krogh.cc>
	<20080508223635.523b8fa7.akpm@linux-foundation.org>
	<4823EA9E.6050703@krogh.cc>
	<18471.41781.164396.385159@notabene.brown>
	<4827E67E.3050008@krogh.cc>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2008 08:41:02 +0200 Jesper Krogh <jesper@krogh.cc> wrote:

> Sorry for all the noise.

It happens.  Reporting a possible kernel bug is better than remaining silent
or working around it or waiting indefinitely until you're sure it's a kernel
bug, etc.

Thanks for the update.
