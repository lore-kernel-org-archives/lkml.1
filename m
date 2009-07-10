Return-Path: <linux-kernel-owner+w=401wt.eu-S1754448AbZGJR0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448AbZGJR0Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 13:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750991AbZGJR0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 13:26:04 -0400
Received: from fifo99.com ([67.223.236.141]:43113 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbZGJR0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 13:26:04 -0400
Subject: Re: HTC Dream: qdsp support for staging
From: Daniel Walker <dwalker@fifo99.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: greg@kroah.com, swetland@google.com, malchev@google.com,
       kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <20090710083709.GA6418@elf.ucw.cz>
References: <20090710083709.GA6418@elf.ucw.cz>
Content-Type: text/plain
Date: Fri, 10 Jul 2009 10:25:57 -0700
Message-Id: <1247246757.7146.33.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-10 at 10:37 +0200, Pavel Machek wrote:
> From: Iliyan Malchev <ibm@android.com>
> 
> QDSP code is neccessarry for communication with some hardware
> components on HTC Dream, including camera hardware. It also drives DSP
> coproccessor.
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>


You don't want to break it up into multiple patches? I'll do it if you
don't want too ..

Daniel

