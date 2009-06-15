Return-Path: <linux-kernel-owner+w=401wt.eu-S1754895AbZFOFoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbZFOFoK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 01:44:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbZFOFn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 01:43:58 -0400
Received: from ozlabs.org ([203.10.76.45]:58134 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbZFOFn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 01:43:58 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 4/17] cpumask: remove the now-obsoleted pcibus_to_cpumask(): sh
Date: Mon, 15 Jun 2009 15:13:57 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>
References: <20090612133105.E5D7ADDD0C@ozlabs.org> <20090612132556.EEAEADDD04@ozlabs.org> <20090615024520.GA31902@linux-sh.org>
In-Reply-To: <20090615024520.GA31902@linux-sh.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906151513.57984.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jun 2009 12:15:20 pm Paul Mundt wrote:
> I've taken these in to the sh tree, thanks. They'll be included in the
> next round of updates for -rc1.
>
> I'm not sure how you want to handle the remaining patches. The
> outstanding ones obviously touch code all over the place and should
> probably go in in one go after the merge window has settled down a bit.

Thanks, that's the basic plan.  They'll sit in linux-next until then.

(The other option was for you to just ack them and they'll go with the rest to 
Linus; in fact, that's going to happen to maintainers who don't respond anyway 
:)

Cheers,
Rusty.

