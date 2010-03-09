Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab0CIUGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 15:06:55 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:54136 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821Ab0CIUGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 15:06:53 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: Re: [PATCH 3/3] input: remove BKL from serio_raw
Date: Tue, 9 Mar 2010 21:06:50 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, John Kacur <jkacur@gmail.com>
References: <1268162386-2745-1-git-send-email-cascardo@holoscopio.com> <1268162386-2745-2-git-send-email-cascardo@holoscopio.com> <1268162386-2745-3-git-send-email-cascardo@holoscopio.com>
In-Reply-To: <1268162386-2745-3-git-send-email-cascardo@holoscopio.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201003092106.51075.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+Fnx9uDKwwNPKkW+hBUh1cGXLiwC6JWachzyo
 sOlIG3bisryqLS95FBHY82yghHWF2hEmLMl9q9SH3XqnwvDZbd
 xLeK4QgkPaTESl8KD2W3A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 March 2010, Thadeu Lima de Souza Cascardo wrote:
> serio_raw open function already uses a mutex.
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
