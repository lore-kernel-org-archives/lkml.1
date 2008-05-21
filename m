Return-Path: <linux-kernel-owner+w=401wt.eu-S1764070AbYEUFsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764070AbYEUFsE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 01:48:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754757AbYEUFrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 01:47:53 -0400
Received: from hu-out-0506.google.com ([72.14.214.230]:16985 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059AbYEUFrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 01:47:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=K7K77Bi/gaN6gYtg0laL4J2GMaPVS1h889f0Ak7uXC4YBprqIHX+LBTGU1hidGZBQ1a5Ulo21jHB7cfR/j9cmqnBPbWFivb2ACivbeBQj0XFw6g4zIjTJvyz3o835WSZhN8M6KFWuQLduRyi58bmUzci0qC9eBkYWeXtSKWNb6U=
Date: Wed, 21 May 2008 08:47:45 +0300
From: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, yi.zhu@intel.com,
       reinette.chatre@intel.com, linux-wireless@vger.kernel.org,
       ipw3945-devel@lists.sourceforge.net, johannes@sipsolutions.net,
       flamingice@sourmilk.net
Subject: Re: regression iwl3945/mac80211: association times out since
	2.6.26-rc1
Message-ID: <20080521054743.GA9910@robinhood.home>
References: <20080520184859.GA8168@robinhood.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080520184859.GA8168@robinhood.home>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FYI, I created an item in bugzilla to track this
http://bugzilla.kernel.org/show_bug.cgi?id=10765
