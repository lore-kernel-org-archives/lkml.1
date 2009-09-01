Return-Path: <linux-kernel-owner+w=401wt.eu-S1755393AbZIAX1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbZIAX1f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 19:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755362AbZIAX1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 19:27:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48046 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755353AbZIAX1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 19:27:34 -0400
Date: Tue, 1 Sep 2009 16:27:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dac960: switch to seq_file
Message-Id: <20090901162735.d30cee12.akpm@linux-foundation.org>
In-Reply-To: <20090828195814.GE15123@x200.localdomain>
References: <20090828195814.GE15123@x200.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Aug 2009 23:58:14 +0400
Alexey Dobriyan <adobriyan@gmail.com> wrote:

>  drivers/block/DAC960.c |  156 ++++++++++++++++++++++---------------------------

hm, that's a large change to a hard-to-change driver.

Is it correct?
