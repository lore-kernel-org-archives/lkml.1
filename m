Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968495Ab0B0PMg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 10:12:36 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:58821 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S964958Ab0B0PMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 10:12:35 -0500
Date: Sat, 27 Feb 2010 18:12:33 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: linux-kernel@vger.kernel.org, Anton Vorontsov <cbouatmailru@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Rodolfo Giometti <giometti@linux.it>
Subject: Re: [PATCH 2/2] power_supply: bq27x00: fix voltage and current
 units
Message-ID: <20100227151233.GB10121@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <1267283204-19181-1-git-send-email-notasas@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1267283204-19181-1-git-send-email-notasas@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 27, 2010 at 05:06:44PM +0200, Grazvydas Ignotas wrote:
> The chip returns voltage and current in mV and mA, but
> power supply class uses uV and uA, so add missing conversion.
> 
> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
> ---

Applied.

Thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
