Return-Path: <linux-kernel-owner+w=401wt.eu-S1753298AbYLBEuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbYLBEuT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 23:50:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbYLBEuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 23:50:04 -0500
Received: from mail-gx0-f18.google.com ([209.85.217.18]:34605 "EHLO
	mail-gx0-f18.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbYLBEuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 23:50:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=v4pSBjaumMpdNyDDBoc1RSHTkBoNPUKI5bBW+jrym5Z7oQ+Xyyc9xnwySsqOxuRtlu
         XLmwkqYB0HWAg+TCk7N4sQmwfnRCqZDlA+cVgj05oQjAwr7FsayUfQy+/FmxGOCygmB+
         sgNH4PkdYy/MgWZs6Locgze5TmzfNSIpiWSQY=
Message-ID: <43e72e890812012049pef0ea61m551b6c06296fa83a@mail.gmail.com>
Date: Mon, 1 Dec 2008 20:49:59 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: [ath5k-devel] License of changes to ath5k/ath9k
Cc: "ath5k-devel@lists.ath5k.org" <ath5k-devel@venema.h4ckr.net>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
       "bkuhn@softwarefreedom.org" <bkuhn@softwarefreedom.org>,
       "Luis Rodriguez" <Luis.Rodriguez@atheros.com>
In-Reply-To: <b6c5339f0811261753o345283c2g9c35d3281d8e4e6d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081125210421.GF5950@tesla>
	 <b6c5339f0811251329h1130fd4aladcbfda52f0542eb@mail.gmail.com>
	 <20081125222814.GG5950@tesla>
	 <b6c5339f0811261753o345283c2g9c35d3281d8e4e6d@mail.gmail.com>
X-Google-Sender-Auth: 65eb2393417d9dab
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/26 Bob Copeland <me@bobcopeland.com>:
> On Tue, Nov 25, 2008 at 5:28 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
>> Sure, BTW I had created such a script a long time ago, the files just
>> need to be updated (so update them if you download this thingy):
>>
>> http://www.kernel.org/pub/linux/kernel/people/mcgrof/scripts/ath5k-license.pl.txt
>>
>
> Cool, that saved me some work.  I updated this so that the files are
> now up-to-date, and it can be called directly from the commit-msg hook
> (also handles existing Signed-off-by etc).  Feel free to take whatever
> you like from my version.

I've updated the file with your stuff, thanks!

  Luis
