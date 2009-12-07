Return-Path: <linux-kernel-owner+w=401wt.eu-S934672AbZLGM0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934672AbZLGM0p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 07:26:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933268AbZLGM0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 07:26:45 -0500
Received: from mail.enyo.de ([212.9.189.167]:32854 "EHLO mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933161AbZLGM0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 07:26:44 -0500
X-Greylist: delayed 2379 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Dec 2009 07:26:44 EST
From: Florian Weimer <fw@deneb.enyo.de>
To: tarek attia <tarek.m.attia@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Sun-java5-sdk installing
References: <82cfbe860912070340k6c1a3560u14e4f628f8202b23@mail.gmail.com>
Date: Mon, 07 Dec 2009 12:47:10 +0100
In-Reply-To: <82cfbe860912070340k6c1a3560u14e4f628f8202b23@mail.gmail.com>
	(tarek attia's message of "Mon, 7 Dec 2009 13:40:51 +0200")
Message-ID: <873a3n80qp.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* tarek attia:

> I got stuck in installing sun-java5 sdk on Karmic .
>
> # apt-get install sun-java5-jdk
> Reading package lists... Done
> Building dependency tree
> Reading state information... Done
> E: Couldn't find package sun-java5-jdk
>
> any idea?

You're asking the wrong mailing list.

Java 5 SE is obsolete technology.  The public releases are no longer
supported by Sun:

<http://java.sun.com/products/archive/eol.policy.html>

You should switch to Java 6 or OpenJDK.
