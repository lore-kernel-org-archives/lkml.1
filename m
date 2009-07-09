Return-Path: <linux-kernel-owner+w=401wt.eu-S1759321AbZGIHMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759321AbZGIHMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 03:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758297AbZGIHMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 03:12:22 -0400
Received: from emita2.mittwald.de ([85.199.173.189]:54071 "EHLO
	emita2.mittwald.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758056AbZGIHMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 03:12:21 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [regression] ath5k: Overrides regulatory domain set for cfg80211
Date: Thu, 9 Jul 2009 09:05:27 +0200
User-Agent: KMail/1.9.7
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, Frans Pop <elendil@planet.nl>,
       netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200907082340.07787.elendil@planet.nl> <43e72e890907081508n6fa5781an1dcbda078efc5379@mail.gmail.com>
In-Reply-To: <43e72e890907081508n6fa5781an1dcbda078efc5379@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907090905.27154.hs4233@mail.mn-solutions.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Eventually, as you will read from the feature-removal
> schedule, we intend on getting the Linux desktop to provide
> automatic hints of the user's location through things like
> GeoClue.

Please think about embedded people. We don't need no stinkin' 
geoclue. We'll need a kernel parameter or an commant for "iw" or 
some other netlink based command.

-- 
http://www.holgerschurig.de
