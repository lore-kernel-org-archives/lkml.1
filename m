Return-Path: <linux-kernel-owner+w=401wt.eu-S1761930AbYEHLAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761930AbYEHLAg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 07:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbYEHLAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 07:00:24 -0400
Received: from saeurebad.de ([85.214.36.134]:47238 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192AbYEHLAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 07:00:22 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Pavel Machek <pavel@suse.cz>, kernel list <linux-kernel@vger.kernel.org>,
       webmaster@kernel.org
Subject: Re: git.kernel.org does not list all the git trees
References: <20080507205821.GC18782@elf.ucw.cz> <48223998.2000904@kernel.org>
Date: Thu, 08 May 2008 13:00:11 +0200
In-Reply-To: <48223998.2000904@kernel.org> (H. Peter Anvin's message of "Wed,
	07 May 2008 16:22:00 -0700")
Message-ID: <87bq3hoybo.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

"H. Peter Anvin" <hpa@kernel.org> writes:

> Pavel Machek wrote:
>> Hi!
>>
>> Go to git.kernel.org, click "owner" to sort by owner, last tree is by
>> "Jeremy Kerr", which I don't believe is right.
>>
>
> I just tried it, and it ends with "Zach Brown".
>
> We have had problems with occasional truncation of the front page;
> unfortunately we don't have enough info to discern any pattern what
> would trigger it...

Maybe some sort of time-out?  I had this problem reproducible with a
thin dial-up connection (general front page truncation, no matter what
sorting.  Straight git.kernel.org).  Never again with a broader line.

	Hannes
