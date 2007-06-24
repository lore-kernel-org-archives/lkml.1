Return-Path: <linux-kernel-owner+w=401wt.eu-S1756338AbXFXPf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338AbXFXPf0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 11:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753278AbXFXPfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 11:35:18 -0400
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2367 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbXFXPfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 11:35:17 -0400
Message-ID: <467E8F2F.2090409@xs4all.nl>
Date: Sun, 24 Jun 2007 17:35:11 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Folkert van Heusden <folkert@vanheusden.com>
Subject: Re: 2.6.21.4: possible circular locking dependency detected
References: <467AB953.9080106@xs4all.nl> <467ABCAD.7070304@xs4all.nl>
In-Reply-To: <467ABCAD.7070304@xs4all.nl>
X-Enigmail-Version: 0.95.1
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Udo van den Heuvel wrote:
> Udo van den Heuvel wrote:
> 
>> While copying a small file over to a windows box via cifs, once again I
>> got something like this:
> 
> Again with 2.6.21.5:
> 
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.21.5 #10
> -------------------------------------------------------
(cut)

There is a bugzilla entry with some more info.
http://bugzilla.kernel.org/show_bug.cgi?id=8377

It looks like the bug has been there for a while. When will it go?
Networking (at least) is not reliable in my situation.

