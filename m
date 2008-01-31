Return-Path: <linux-kernel-owner+w=401wt.eu-S1762616AbYAaOlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762616AbYAaOlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 09:41:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754932AbYAaOlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 09:41:45 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:40565 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513AbYAaOlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 09:41:45 -0500
Date: Thu, 31 Jan 2008 06:41:28 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: devzero@web.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: introduce /dev/mem restrictions with a config
 option
Message-ID: <20080131064128.58c516da@laptopd505.fenrus.org>
In-Reply-To: <137932353@web.de>
References: <137932353@web.de>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008 15:04:28 +0100
devzero@web.de wrote:

> nice !
> 
> did you think about some boot-time param , e.g. "insecure-devmem" or
> something like that?
> 
> recompiling kernel is time consuming.....

given that this has been in fedora/rhel for 5 years with no complaints...
it's extremely rare, and if you are someone who's going to use it to do some weird
form of kernel debugging, you already know that way ahead of time, when you
compile your kernel.
(Note: I don't know of any tools that do kernel debugging this way. At all)
