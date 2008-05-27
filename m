Return-Path: <linux-kernel-owner+w=401wt.eu-S1757272AbYE0I0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272AbYE0I0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 04:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755626AbYE0I0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 04:26:09 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:34355 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593AbYE0I0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 04:26:08 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: "Justin Mattock" <justinmattock@gmail.com>
Subject: Re: appletouch after wakeup
Date: Tue, 27 May 2008 10:40:43 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <dd18b0c30805262029me288690y237f995fb63ccf54@mail.gmail.com>
In-Reply-To: <dd18b0c30805262029me288690y237f995fb63ccf54@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805271040.44203.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 27. Mai 2008 05:29:04 schrieb Justin Mattock:
> Hello; with 2.6.26-rc3 I've notice appletouch is going out of whack,
> here's what I see after waking the machine from suspend,
> [ 8186.661313] appletouch: incomplete data package (first byte: 2, length: 4).
> Keep in mind there is not just one of these messages, the entire dmesg
> is filled.

Immediately after resumption? STR or STD?

	Regards
		Oliver

