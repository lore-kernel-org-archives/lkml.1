Return-Path: <linux-kernel-owner+w=401wt.eu-S966226AbXDGR7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966226AbXDGR7z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 13:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966221AbXDGR7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 13:59:55 -0400
Received: from smtp.osdl.org ([65.172.181.24]:58276 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966197AbXDGR7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 13:59:54 -0400
Date: Sat, 7 Apr 2007 10:59:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/4] clean up identify_cpu
Message-Id: <20070407105947.15128675.akpm@linux-foundation.org>
In-Reply-To: <4617D2D1.7040202@goop.org>
References: <20070406224152.556848893@goop.org>
	<20070406224204.782242327@goop.org>
	<20070407021401.a993892b.akpm@linux-foundation.org>
	<4617D2D1.7040202@goop.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 07 Apr 2007 10:20:17 -0700 Jeremy Fitzhardinge <jeremy@goop.org> wrote:

>  I don't have a x86-64 compile environment on
> hand, so the 64 bits are completely untested

http://userweb.kernel.org/~akpm/cross-compilers/
