Return-Path: <linux-kernel-owner+w=401wt.eu-S1753929AbYIERoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929AbYIERoh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 13:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbYIERo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 13:44:28 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:34619 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbYIERo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 13:44:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=uoqW+1kE5sMT7VK/RK7W2Wk/fxxFGUI/I1Vawp/tyl0sy+54W/SSQVSObe4OvNArh5
         OqpKGNo2B0u2onraiS4qDdTpqz4oe+L6lGXsXNMWoqATPVqkg4IcRuhVHY63U87+GT4S
         flwqEDPn36J/BmcDQwbO9P0yu2De8yxFIHpPA=
Message-ID: <43e72e890809051044n20826243jab4606b7baf57b0@mail.gmail.com>
Date: Fri, 5 Sep 2008 10:44:26 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: Re: [PATCH 1/2] cfg80211: Add new wireless regulatory infrastructure
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1220484624-7808-2-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1220484624-7808-1-git-send-email-lrodriguez@atheros.com>
	 <1220484624-7808-2-git-send-email-lrodriguez@atheros.com>
X-Google-Sender-Auth: ff3d47919bd111c8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 3, 2008 at 4:30 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:

> +#undef OLD_FREQ

Doh this is spurious, I forgot to remove the undef as I am not using
it. Going to resent without this.

 Luis
