Return-Path: <linux-kernel-owner+w=401wt.eu-S1755472AbZIUC7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbZIUC7V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 22:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755419AbZIUC7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 22:59:20 -0400
Received: from dd2934.kasserver.com ([85.13.129.136]:45245 "EHLO
	dd2934.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026AbZIUC7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 22:59:19 -0400
Message-ID: <4AB6EC09.9010808@datenparkplatz.de>
Date: Mon, 21 Sep 2009 04:59:21 +0200
From: Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Poor desktop responsiveness with background I/O-operations
References: <4AB59CBB.8090907@datenparkplatz.de> <alpine.LRH.2.00.0909202221010.25928@twin.jikos.cz>
In-Reply-To: <alpine.LRH.2.00.0909202221010.25928@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> I guess that switching from CFQ to deadline I/O scheduler improves the 
> situation, right?


Indeed, there is an improvement. But, especially in the case with an
encrypted /home, copying a large file from a fast source means I better
go get another cup of coffee rather than continue working on something
else in the meantime.


BTW, I've tested this with a default install of
OpenSUSE 11.1, and I get basically the same behaviour.

