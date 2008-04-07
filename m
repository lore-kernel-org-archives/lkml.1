Return-Path: <linux-kernel-owner+w=401wt.eu-S1756866AbYDGVsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866AbYDGVsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 17:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757050AbYDGVsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 17:48:20 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:9750 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756885AbYDGVsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 17:48:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uYIAjSDQcaXICrB+Avi51j+hZC3lph2um7ekXyn1z+dlFkS42iFkLMJ4rys6UnqCM1VeHm/YHyjFNk/FOYAgH8Pbb9CywDuWgQNxYGsfQ/FjpGra7/YkSi48B6/aCgKdKe+aF1TlLeooVo6mujvIoHi8jbgI++mI0Z+spni87JE=
Message-ID: <f6ca9fed0804071448j34419f9encba8fd42599b7d65@mail.gmail.com>
Date: Mon, 7 Apr 2008 23:48:17 +0200
From: drago01 <drago01@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH 1/2] mac80211: fix recursive locking in ieee80211_sta_expire
Cc: linville@tuxdriver.com, "Andrew Morton" <akpm@linux-foundation.org>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Michael Wu" <flamingice@sourmilk.net>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       "Jiri Benc" <jbenc@suse.cz>
In-Reply-To: <1207598029-20000-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1207598029-20000-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 7, 2008 at 9:53 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> Hi,
>
>  it's against -mm, what's current mac80211 git tree? It seems that
>  -mm has fresher material, than wireless-2.6...

The current tree is wireless-testing
