Return-Path: <linux-kernel-owner+w=401wt.eu-S1755565AbYAZUmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbYAZUmw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 15:42:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753597AbYAZUml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 15:42:41 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:39083 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055AbYAZUml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 15:42:41 -0500
Date: Sat, 26 Jan 2008 21:42:39 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Frans Pop <elendil@planet.nl>
cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>  (linux.*
 mail to news gateway)
In-Reply-To: <E1JIrgj-0005cj-Gv@faramir.fjphome.nl>
Message-ID: <Pine.LNX.4.64.0801262142300.15243@fbirervta.pbzchgretzou.qr>
References: <200801262043.17739.bzolnier@gmail.com> <E1JIrgj-0005cj-Gv@faramir.fjphome.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 26 2008 21:31, Frans Pop wrote:
>>  config BLK_DEV_IDE_PMAC
>> -       bool "Builtin PowerMac IDE support"
>> +       tristate "Builtin PowerMac IDE support"
>
>This does not seem to make sense: if the option is now tristate, it is no
>longer "Builtin", so probably s/Builtin // in the description.

Or something like s/Builtin/Onboard/;
