Return-Path: <linux-kernel-owner+w=401wt.eu-S1760645AbYF0Mfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760645AbYF0Mfc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754725AbYF0MfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 08:35:12 -0400
Received: from saeurebad.de ([85.214.36.134]:39350 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756087AbYF0MfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 08:35:11 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mmotm] fix double export of kobject_rename
References: <87wskbxg1o.fsf@skyscraper.fehenstaub.lan>
	<Pine.LNX.4.64.0806271256570.16003@blonde.site>
Date: Fri, 27 Jun 2008 14:34:39 +0200
In-Reply-To: <Pine.LNX.4.64.0806271256570.16003@blonde.site> (Hugh Dickins's
	message of "Fri, 27 Jun 2008 12:57:34 +0100 (BST)")
Message-ID: <87lk0rxdi8.fsf@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Hugh Dickins <hugh@veritas.com> writes:

> On Fri, 27 Jun 2008, Johannes Weiner wrote:
>
>> Probably a merging error, line comes from the merge with -next.
>> 
>> Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
>> ---
>
> Please try yesterday's .DATE=2008-06-26-14-32 mmotm,
> I sent Andrew a similar fix and it should be okay now.
> Also includes fix to endless bad page states once you boot.

Crap, I must have checked it out just before he updated it.  Thanks,
Hugh.

	Hannes
