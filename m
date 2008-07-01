Return-Path: <linux-kernel-owner+w=401wt.eu-S1761657AbYGAW25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761657AbYGAW25 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 18:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758312AbYGAW2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 18:28:38 -0400
Received: from xenotime.net ([66.160.160.81]:57340 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758056AbYGAW2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 18:28:37 -0400
Date: Tue, 1 Jul 2008 15:28:29 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: Donkey Ia <d0nk3y.ia@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: option of kernel config
In-Reply-To: <f2ae95280807011525t250ff74k2f20d876860f34e6@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0807011527370.26330@shark.he.net>
References: <f2ae95280807011525t250ff74k2f20d876860f34e6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1606286688-630557147-1214951309=:26330"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1606286688-630557147-1214951309=:26330
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 2 Jul 2008, Donkey Ia wrote:

> Please, excuse me - probably it's a very stupid question for this
place, but i need to know - could you tell me please, =FF=FFwhich exactly
option (or maybe options) of kernel config calls ide hard disks
/dev/sdX instead /dev/hdX?


Using ATA instead of IDE drivers does that.  This menu item:

menuconfig ATA
=09tristate "Serial ATA (prod) and Parallel ATA (experimental) drivers"

--=20
~Randy
---1606286688-630557147-1214951309=:26330--
