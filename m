Return-Path: <linux-kernel-owner+w=401wt.eu-S964908AbXIBH6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964908AbXIBH6b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 03:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754095AbXIBH6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 03:58:20 -0400
Received: from rune.sasl.smtp.pobox.com ([208.210.124.37]:34193 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001AbXIBH6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 03:58:19 -0400
From: Junio C Hamano <gitster@pobox.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: git@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] GIT 1.5.3
References: <7vodglr32i.fsf@gitster.siamese.dyndns.org>
	<46DA5F33.2020005@zytor.com>
Date: Sun, 02 Sep 2007 00:58:15 -0700
In-Reply-To: <46DA5F33.2020005@zytor.com> (H. Peter Anvin's message of "Sun,
	02 Sep 2007 07:58:59 +0100")
Message-ID: <7vr6lhpkh4.fsf@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Junio C Hamano wrote:
>>
>> * For people who need to import from Perforce, a front-end for
>>   fast-import is in contrib/fast-import/.
>
> There seems to be an issue with this and RPMS.
>
> In particular, there is no longer a git-p4 RPMS, which prevents git
> from getting upgraded at all by yum.
>
> Anyone who knows yum well enough to explain what needs to be done so
> that yum knows this is obsolete?

Geez.  Is this only about upgrading, or is initial install also
affected?
