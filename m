Return-Path: <linux-kernel-owner+w=401wt.eu-S1753633AbYKYVaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbYKYVaN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 16:30:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbYKYV35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 16:29:57 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:59276 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbYKYV34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 16:29:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=wXc9MPYdSpG7GukRgava5laG6jroj3pdGMA6vVBo4Rp5K86dbvib08aT/7Sv+l60/O
         Tud9YoR6v2FtN2fxsg3jcbD8hJLWi4yQ5uxeNsGOqaJIz4YwElp3JJJWmmKkgcXZaZ7E
         vc2nFhDsBDgxwfNS611qN802G55NFuoiccndQ=
Message-ID: <b6c5339f0811251329h1130fd4aladcbfda52f0542eb@mail.gmail.com>
Date: Tue, 25 Nov 2008 16:29:55 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [ath5k-devel] License of changes to ath5k/ath9k
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       ath9k-devel@venema.h4ckr.net, ath5k-devel@venema.h4ckr.net,
       bkuhn@softwarefreedom.org
In-Reply-To: <20081125210421.GF5950@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081125210421.GF5950@tesla>
X-Google-Sender-Auth: 7c858c72a73cb089
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2008 at 4:04 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> We'll keep using the ath5k Changes-licensed-under tag until we get
> advice from SFLC if we have done enough to ensure this is no longer
> necessary. For ath9k, if we are not sure if you have read the
> "Developer's Certificate of Origin 1.1" we may ping you with an e-mail
> just to be sure.

I don't consider any of my changes significant enough to confer copyright,
so by my Signed-off-by, I agree that whatever license the file currently
has is alright by me.  Even if the changes were significant, the previous
holds.

However, if everyone + SFLC prefers that we strictly use
Changes-licensed-under even if we don't claim copyright, then I'll
happily add the tag generator script to a git commit hook :)

> Ps. Please do not open any can of worms here, this is just informational.

Sure.  I like the ath9k way, but really it doesn't matter that much.

-- 
Bob Copeland %% www.bobcopeland.com
