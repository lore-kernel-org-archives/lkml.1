Return-Path: <linux-kernel-owner+w=401wt.eu-S1751836AbZEUEws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836AbZEUEws (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 00:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750946AbZEUEwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 00:52:39 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:48768 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbZEUEwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 00:52:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:to:cc:subject:references:from:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=MHFYsKTnaZc4iAZ1sY0vRVG1KGKzIAOjuKRTI00ifF4x5fMeLmr+4tuRjm3mMGHKd2
         1X6YP5+2jI190udLYvnXR8UObW6fjdHI4h8RpRaJ0FoqK+ZYcVrIahzNY6qzYvFa327N
         YYDwoGz4WVAOqZEgldJ9IQPItZGm9qhfLMERI=
To: "Larry H." <research@subreption.com>
Cc: linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>,
       pageexec@freemail.hu, linux-wireless@vger.kernel.org
Subject: Re: [patch 2/5] Apply the PG_sensitive flag to mac80211 WEP key handling
References: <20090520184713.GB10756@oblivion.subreption.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 21 May 2009 07:52:36 +0300
In-Reply-To: <20090520184713.GB10756@oblivion.subreption.com> (Larry H.'s message of "Wed\, 20 May 2009 11\:47\:13 -0700")
Message-ID: <87ljorm50r.fsf@litku.valot.fi>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Larry H." <research@subreption.com> writes:

> This patch deploys the use of the PG_sensitive page allocator flag
> within the mac80211 driver, more specifically the handling of WEP
> RC4 keys during encryption and decryption.

Why? Always explain the reason for the change in commit log. For
example, I have no idea why you want to change this.

> Signed-off-by: Larry H. <research@subreption.com>

Please add your last name.

-- 
Kalle Valo
