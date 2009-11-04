Return-Path: <linux-kernel-owner+w=401wt.eu-S1756525AbZKDPGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525AbZKDPGO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 10:06:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756168AbZKDPGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 10:06:13 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:43589 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012AbZKDPGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 10:06:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=JP1YEzguUBsvwJR+urvMJLcyW5Lv5pM4LVbpnHqjPWUY5a5O5r8BakOOQfFTaUMXtp
         uMGqvEi5795bXlLezwHLDWF1P/K299TcdD1Vod4Aak9GuyP7HI/EjyzekE2z3Er1wSC5
         ryOYfVgooKxP4iDjPgY8r9I28cyJniGRA/CGY=
Message-ID: <4AF198B4.40801@gmail.com>
Date: Wed, 04 Nov 2009 17:07:32 +0200
From: Tommi Rantala <tt.rantala@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Aaro Koskinen <aaro.koskinen@nokia.com>
CC: linux-input@vger.kernel.org, linux-omap@vger.kernel.org,
       linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
       tony@atomide.com
Subject: Re: [PATCH v2 2/2] omap: RX-51: enable tsc2005
References: <1257340982-22814-1-git-send-email-aaro.koskinen@nokia.com> <1257340982-22814-2-git-send-email-aaro.koskinen@nokia.com>
In-Reply-To: <1257340982-22814-2-git-send-email-aaro.koskinen@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aaro Koskinen wrote:
> +static struct spi_board_info rx51_peripherals_spi_board_info[] = {

This can be marked with __initdata.

BR,
Tommi Rantala
