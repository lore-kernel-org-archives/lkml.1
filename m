Return-Path: <linux-kernel-owner+w=401wt.eu-S1756122AbZDRIMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbZDRIMM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 04:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757388AbZDRILw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 04:11:52 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47250 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345AbZDRILv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 04:11:51 -0400
To: "Phil Endecott" <phil_wueww_endecott@chezphil.org>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: /dev/vcs - poll for changes?
From: Andi Kleen <andi@firstfloor.org>
References: <1239980726652@dmwebmail.dmwebmail.chezphil.org>
Date: Sat, 18 Apr 2009 10:11:44 +0200
In-Reply-To: <1239980726652@dmwebmail.dmwebmail.chezphil.org> (Phil Endecott's message of "Fri, 17 Apr 2009 16:05:26 +0100")
Message-ID: <87ocuuqt33.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Phil Endecott" <phil_wueww_endecott@chezphil.org> writes:

> Dear Experts,
>
> Is there a way to detect when the content of a /dev/vcs* has changed?
> I have some code that currently polls, which is obviously sub-optimal.
> I was hoping that there would be some trick like look at the
> modification time, but I haven't found anything.  If this isn't
> currently possible, how easily could it be added?  What would the
> preferred API be, if it were added?

The first question would be: why do you want to do this?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
