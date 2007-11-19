Return-Path: <linux-kernel-owner+w=401wt.eu-S1754314AbXKSQkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbXKSQkl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 11:40:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753190AbXKSQkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 11:40:33 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43545 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbXKSQkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 11:40:33 -0500
Date: Mon, 19 Nov 2007 08:38:15 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Ram <vshrirama@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Debugging uninterruptible sleep causing drivers
Message-ID: <20071119083815.4e520c83@laptopd505.fenrus.org>
In-Reply-To: <8bf247760711190509s20527d86nd79dcf7a9b8b9095@mail.gmail.com>
References: <8bf247760711190509s20527d86nd79dcf7a9b8b9095@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2007 18:39:03 +0530
Ram <vshrirama@gmail.com> wrote:

> Hi,
>    Would like some advices on how to debug a driver which causes a
> processes to go into
> uninterruptible sleep.
> 
> Am trying to debug a  bug which makes my video driver to go into
> an sleep/busywaiting. (when i do 'ps -l' find a 'D' in the stat
> field).
> 
> 99% of the time the driver works,
> 
> However when i try to run both the video and the audio
> driver.(streaming audio and video)
> The video driver sometimes goes into busywaiting/sleep.
> 
> My driver contains lots of spinlocks and semaphores. I have no clue
> on how to solve this issues.
> 

it starts by posting a URL to the (full) source code... without that..
how are people supposed to help you?


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
