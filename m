Return-Path: <linux-kernel-owner+w=401wt.eu-S1755782AbYAZUby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782AbYAZUby (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 15:31:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753412AbYAZUbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 15:31:45 -0500
Received: from hpsmtp-eml13.kpnxchange.com ([213.75.38.113]:49388 "EHLO
	hpsmtp-eml13.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752799AbYAZUbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 15:31:44 -0500
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>  (linux.* mail to news gateway)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
In-reply-To: <200801262043.17739.bzolnier@gmail.com>
References: <200801262043.17739.bzolnier@gmail.com>
Message-Id: <E1JIrgj-0005cj-Gv@faramir.fjphome.nl>
From: Frans Pop <elendil@planet.nl>
Date: Sat, 26 Jan 2008 21:31:41 +0100
X-OriginalArrivalTime: 26 Jan 2008 20:31:42.0048 (UTC) FILETIME=[75D81E00:01C8605A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  config BLK_DEV_IDE_PMAC
> -       bool "Builtin PowerMac IDE support"
> +       tristate "Builtin PowerMac IDE support"

This does not seem to make sense: if the option is now tristate, it is no
longer "Builtin", so probably s/Builtin // in the description.

Cheers,
FJP
