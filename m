Return-Path: <linux-kernel-owner+w=401wt.eu-S1753281AbZIGNMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbZIGNMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 09:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753081AbZIGNMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 09:12:21 -0400
Received: from mail-vw0-f195.google.com ([209.85.212.195]:34135 "EHLO
	mail-vw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbZIGNMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 09:12:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Gy5z/wok3ywvQ8XdL6kEvZceZOTVjuMM7Hl+MrIPbyKEp9HcAC4yvKOBCBak8Z/R5Y
         5voScC/NibWYxo3Pr6VT3Sn+ZYiHoa4UI6M9fh7+gBM0s0JbN7mo0aZinVu1E7fRXLyA
         H3U9AQsP8NolDCuA/MnQo+LdOZ8YDl92UgcCA=
MIME-Version: 1.0
In-Reply-To: <4AA4FA5B.8030804@googlemail.com>
References: <4AA4FA5B.8030804@googlemail.com>
Date: Mon, 7 Sep 2009 09:12:23 -0400
X-Google-Sender-Auth: 0bf927a22a74c5ff
Message-ID: <b6c5339f0909070612q11b96e02m978564f7b89c5954@mail.gmail.com>
Subject: Re: Bugzilla kernel bug 13948
From: Bob Copeland <me@bobcopeland.com>
To: Gonsolo <gonsolo@gmail.com>
Cc: mick@madwifi-project.org, rjw@sisk.pl, linville@tuxdriver.com,
       torvalds@osdl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 7, 2009 at 8:19 AM, Gonsolo<gonsolo@gmail.com> wrote:
> Hi.
>
> Is this going to be in 2.6.31?
> http://bugzilla.kernel.org/show_bug.cgi?id=13948
> It seems that a patch is available but it doesn't show up in mainline.

No it will not.  We were too late to send the patch before "last call"
in the network subsystem.  It should be in 2.6.31.1 though.

-- 
Bob Copeland %% www.bobcopeland.com
