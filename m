Return-Path: <linux-kernel-owner+w=401wt.eu-S1753356AbZKATGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbZKATGK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 14:06:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753315AbZKATGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 14:06:09 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:26155 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbZKATGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 14:06:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=cj7eLUvlI8Kt7jI6n8mbdz60DP3jRgCU6thFtPYDpRy4/SYh+vQC+TW08qd/iTZ1BH
         ta3G7yle4NLm0IEfQ3vcE0r5z/fsI1PZ0jEm209YPOEeKRZmcKhbKd4TjLhwk+yS2I7v
         Y6M7LM8MT5oPTobVWxolNOSnsGBJak8fqaYqA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: pull request: wireless-next-2.6 2009-10-28
Date: Sun, 1 Nov 2009 20:04:59 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: Jarek Poplawski <jarkao2@gmail.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1256886023.3555.5.camel@johannes.local> <20091030110616.GB6150@ff.dom.local> <20091030150223.GA2586@tuxdriver.com>
In-Reply-To: <20091030150223.GA2586@tuxdriver.com>
MIME-Version: 1.0
Message-Id: <200911012004.59718.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 October 2009 16:02:24 John W. Linville wrote:

> Ever since Bartlomiej decided to tear himself away from
> drivers/staging, he has been nothing but negative -- petty, whining,

I think that you should ping Greg about this since somebody impersonating
for me is sending him patches.  Last week alone over 20 such patches were
merged -- who knows what this person might be planning.. ;)

Probably the following patch was the source of confusion:

	http://patchwork.kernel.org/patch/55076/

It just aligns my personal interests w/ ongoing work done by other people,
hch is working on mac80211 via driver and Greg has announced some time ago
that he was going to work on proper rtl819x support.

-- 
Bartlomiej Zolnierkiewicz
