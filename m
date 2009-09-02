Return-Path: <linux-kernel-owner+w=401wt.eu-S1752227AbZIBNky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbZIBNky (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 09:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbZIBNky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 09:40:54 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:57496 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbZIBNkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 09:40:53 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [2.6.31-rc8] Problem with detect USB devices
Date: Wed, 2 Sep 2009 15:42:11 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.31-rc4-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-usb@vger.kernel.org
References: <8db1092f0909020629v5aab79d8lbfcc8c214622787c@mail.gmail.com>
In-Reply-To: <8db1092f0909020629v5aab79d8lbfcc8c214622787c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909021542.11767.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 2. September 2009 15:29:48 schrieb Maciej Rutecki:
>  have no idea, how debug it. Any help?

We have to find out where the event is lost. Please run
"udevadm monitor" and tell us whether you see an event as
you unplug your device.

	HTH
		Oliver

