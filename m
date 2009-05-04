Return-Path: <linux-kernel-owner+w=401wt.eu-S1753470AbZEDSmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbZEDSmP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 14:42:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbZEDSl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 14:41:57 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:42310 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbZEDSl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 14:41:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=R2bG94m4Dd+YB5afiH9+sf3/SW/m7zoDxN1I+s0MO9TtnAl8mTQmcn7PbHlSIM/0Yi
         NJ2DnHFw183x/no27BllAAOI7N0lXD2s3H6jDkTTDMftGy7mOQKHTNqlp9Slq8Y+ioEf
         +1yUbiTxGQKLma9r944j4eppCKskHIdN92hbU=
Message-ID: <49FF36F6.9050805@gmail.com>
Date: Mon, 04 May 2009 20:41:58 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-8.7 Thunderbird/3.0b2
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH 1/2] mac80211: minstrel, fix memory corruption
References: <1241453096-8517-1-git-send-email-jirislaby@gmail.com> <43e72e890905041138q4bf43405u7fca133dac991dc4@mail.gmail.com>
In-Reply-To: <43e72e890905041138q4bf43405u7fca133dac991dc4@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2009 08:38 PM, Luis R. Rodriguez wrote:
> Cc: stable@kernel.org

Sure, I plan to send a notification to Greg after a SHA from the linus
tree will be known.

Thanks.
