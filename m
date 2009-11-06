Return-Path: <linux-kernel-owner+w=401wt.eu-S1759597AbZKFSUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759597AbZKFSUq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 13:20:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759178AbZKFSUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 13:20:45 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38306 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758204AbZKFSUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 13:20:45 -0500
Date: Fri, 6 Nov 2009 18:22:18 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Martin Schleier" <drahemmaps@gmx.net>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       technoboy85@gmail.com
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091106182218.43940287@lxorguk.ukuu.org.uk>
In-Reply-To: <20091106165731.26800@gmx.net>
References: <20091106154911.29400@gmx.net>
	<20091106155937.11d95279@lxorguk.ukuu.org.uk>
	<20091106165731.26800@gmx.net>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If it wasn't riddled with 19 errors (not bad for only 133 lines),
> I would have bothered to remove these irrelevant lines.

Checkpatch is just formatting - its just an aide nothing more. It's not
remotely useful to bother with them for stuff that is basically sanely
formatted until such point as someone is actually sure the patch is worth
going into the tree.
