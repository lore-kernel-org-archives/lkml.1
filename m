Return-Path: <linux-kernel-owner+w=401wt.eu-S1754686AbYJBJPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbYJBJPA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 05:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753064AbYJBJOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 05:14:52 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60811 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbYJBJOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 05:14:51 -0400
To: Marek Szuba <scriptkiddie@wp.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Regular system 'hiccups' with 2.6.25+ on amd64 machines
From: Andi Kleen <andi@firstfloor.org>
References: <20081001235106.57edede4@ifurita.akmm.lan>
Date: Thu, 02 Oct 2008 11:14:50 +0200
In-Reply-To: <20081001235106.57edede4@ifurita.akmm.lan> (Marek Szuba's message of "Wed, 1 Oct 2008 23:51:06 +0200")
Message-ID: <877i8rpddh.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marek Szuba <scriptkiddie@wp.pl> writes:
>
> I would greatly appreciate it if you could look into the problem and
> let me know what is wrong - i.e. whether this is a bug, an
> unnecessarily-enabled feature, something that just needs a bit of
> tuning and so on. If you need any more information regarding the issue,
> my set-ups and so on, please don't hesitate to contact me (by
> writing to my e-mail address - I'm not subscribed to LKML at present)!

You could do a oprofile run (http://oprofile.sourceforge.net) 
and see if it's something taking a lot of CPU time.

-Andi
-- 
ak@linux.intel.com
