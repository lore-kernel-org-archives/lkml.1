Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932667Ab0CLLOt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 06:14:49 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:48977 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932463Ab0CLLOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 06:14:48 -0500
Subject: Re: Weird wireless/wpa_supplicant screw-up.
From: Johannes Berg <johannes@sipsolutions.net>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <7197.1268086939@localhost>
References: <7197.1268086939@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Mar 2010 03:14:41 -0800
Message-ID: <1268392481.4828.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-08 at 17:22 -0500, Valdis.Kletnieks@vt.edu wrote:
> (This could be user error/userspace bug, feel free to point me in the right
> direction if you think so.  Hopefully somebody knows what I've broken this
> time...)
> 
> Fedora Rawhide as of this morning, 2.6.33-mmotm0304 kernel, wpa_supplicant-0.6.8-8.fc13.x86_64
> wireless-tools-29-5.1.fc12.x86_64.  Dell Latitude E6500, Intel 5100AGN card.
> 
> So I finally get a few spare cycles, and re-try getting WPA2 working on our
> enterprise wireless network, and wpa_supplicant reports it completed
> successfully and set the keys,

and does it work? The iwlist stuff could just be a reporting error...

johannes


