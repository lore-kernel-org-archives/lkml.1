Return-Path: <linux-kernel-owner+w=401wt.eu-S1756576AbXFXSD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbXFXSD0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 14:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbXFXSDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 14:03:17 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42455 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751505AbXFXSDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 14:03:16 -0400
Date: Sun, 24 Jun 2007 11:02:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: djones@rossove.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Scaling Max IP address limitation
Message-Id: <20070624110236.fa36b2f9.akpm@linux-foundation.org>
In-Reply-To: <467EA7C1.4080006@rossove.com>
References: <467EA7C1.4080006@rossove.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jun 2007 12:20:01 -0500 David Jones <djones@rossove.com> wrote:

> Hi,
> I am trying to add multiple IP addresses ( v6 ) to my FC7 box on eth0. 
> But I am hitting a max limit of 4000 IP address . Seems like there is a 
> limiting variable in linux kernel (which one? ) that prevents from 
> adding more IP addresses than 4096. What do I need to change in Linux 
> kernel  ( and then recompile ) to be able to add more IP addresses than 
> 4K addresses per system? ..

(cc netdev)
