Return-Path: <linux-kernel-owner+w=401wt.eu-S1752139Ab0AQMLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab0AQMLc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 07:11:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022Ab0AQMLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 07:11:31 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:35425 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab0AQMLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 07:11:30 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4B52FE6A.4090407@s5r6.in-berlin.de>
Date: Sun, 17 Jan 2010 13:11:22 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100102 SeaMonkey/1.1.18
MIME-Version: 1.0
To: werner@sys-linux.yi.org
CC: linux-kernel@vger.kernel.org
Subject: Re: possible problem with 2.6.33-rc4
References: <1263698405.12452@sys-linux.yi.org>
In-Reply-To: <1263698405.12452@sys-linux.yi.org>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

werner@sys-linux.yi.org wrote:
> The following error messages I received now. I'm not sure if that's a kernel problem
> For make more easy to correct the error, I send the whole syslog, below.
> This is from syslog, because dmesg is to small.  (dmesg always is only half, when
> we finally can get dmesg 1 MB or bigger ??)

It is not explicitly documented, but you can set CONFIG_LOG_BUF_SHIFT to
up to 21, giving you 2 MB dmesg buffer.
-- 
Stefan Richter
-=====-==-=- ---= =---=
http://arcgraph.de/sr/
